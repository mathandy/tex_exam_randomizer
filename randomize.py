#!/usr/bin/env python
# -*- coding: utf-8 -*-

r"""
A tool for randomizing QA ordering in latex exams

Assumptions:
* Assumes all questions are of the form::

    \begin{problem}

        Text/etc to keep at top

        \begin{mchoice}
        Text/etc to keep at top

        \item (or \xtem) anwer choice text
        \item (or \xtem) anwer choice text
        .
        .
        .
        \item (or \xtem) anwer choice text
        \end{mchoice}
    \end{problem}


Usage
-----
If using a master file whose sections are fetched with `input{}`
statements, use the `-m` flag. E.g.::

    $ python randomize.py -m test/base.tex


To randomize the problems and answers in a file with no fixed sections,
omit the `-m` flag.  E.g.::

    $ python randomize.py test/section_*.tex


For more options/help::

    $ python randomize.py -h


License
-------
MIT licensed (Andy Port, October 2018)
"""


from __future__ import print_function, unicode_literals
import os
import re
from random import shuffle
from time import time
from copy import copy


def latex_environment_pattern(env):
    r"""Returns `re` pattern for latex begin-end `env` environment blocks.

    The returned pattern can be used to search for blocks that look like
    ``\begin{`env`}NOT_WHITESPACE (...)\end{`env`}NOT_WHITESPACE``
    where, upon searching with the pattern, (...) will be the returned
    `re.match` object's `self.group(1)`.
    """
    return re.compile(r"[^\s]*\\begin{%s}[^\s]*(.*?)[^\s]*\\end{%s}[^\s]*" % (env, env), re.DOTALL)


def get_problems(filename, debug=False):
    """Get list of problems/answers, and template the full TeX.

    Returns
    -------
    list of problems
        Each problem is represented as a dictionary containing the full
        latex problem block, a list of "answers", and the "beginning"-
        and "ending"-matter that the answers must be sandwiched between
        to reconstruct the original TeX.
    string
        The full contents of `filename` with the problems repaced by
        unique identifiers.
    function
        Given k, returns the unique identifier of the kth problem.
        """
    question_pattern = latex_environment_pattern('problem')
    answer_pattern = latex_environment_pattern('mchoice')

    with open(filename, 'r') as f:
        tex = f.read()

    t = time()
    marker = lambda n: r'##%s-%s' % (int(t), str(n).zfill(6))

    problems = []
    for k, m in enumerate(question_pattern.finditer(tex)):
        problem = m.group()  # full TeX block

        # get answer section (the `\item`s and `\xtem`s)
        answer_section_start = re.search(r'\\xtem|\\item', problem).start()
        answer_section_end = answer_pattern.search(problem).end(1)
        answer_section = problem[answer_section_start: answer_section_end]

        # split answer sections, one entry per `\item` or `\xtem`
        delimiter = '#!%s!#' % t
        answer_choices = answer_section.replace(r'\xtem', delimiter + r'\xtem')
        answer_choices = answer_choices.replace(r'\item', delimiter + r'\item')
        answer_choices = answer_choices.split(delimiter)

        problems.append({'full_tex': problem,
                          'beginning': problem[:answer_section_start],
                          'ending': problem[answer_section_end:],
                          'answers': answer_choices})

        # remove problem from `tex` and leave marker
        tex = tex.replace(problem, marker(k))

    if debug:
        for p in problems:
            print(p['beginning'])
            for a in p['answers']:
                print(a)
            print(p['ending'])
            print('\n\n---\n')
        print("Marked `tex`")
        print(tex)

    return problems, tex, marker


def randomize(problem_list, fix_questions=False, fix_answers=False):
    if not fix_questions:
        shuffle(problem_list)
    if not fix_answers:
        for p in problem_list:
            shuffle(p['answers'])
    return problem_list


def postfix_tag(k, num_versions):
    if num_versions <= 26:
        tags = 'abcdefghijklmnopqrstuvwxyz'
    else:
        tags = map(str, range(num_versions))
    return '_ver_' + tags[k]


def generate_randomized_versions(tex_file, num_versions=4,
                                 output_dir=os.getcwd(),
                                 fix_questions=False,
                                 fix_answers=False, debug=False):

    problems, tex, marker = get_problems(filename=tex_file, debug=debug)

    name, ext = os.path.splitext(os.path.basename(tex_file))
    for iv in range(num_versions):
        problems = randomize(problems, fix_questions, fix_answers)
        version_filename = \
            os.path.join(output_dir, name + postfix_tag(iv, num_versions) + ext)
        version_tex = copy(tex)

        for k, p in enumerate(problems):
            p_block = p['beginning'] + ''.join(p['answers']) + p['ending']
            version_tex = version_tex.replace(marker(k), p_block)
        with open(version_filename, 'w+') as f:
            f.write(version_tex)
        print('"%s" created' % version_filename)

    if debug:
        with open(os.path.join(output_dir, 'debug_marked.tex'), 'w') as f:
            f.write(tex)


def generate_randomized_versions_multi(tex_files, num_versions=4,
                                 output_dir=os.getcwd(), fix_questions=False,
                                 fix_answers=False, debug=False):
    for tex_file in tex_files:
        generate_randomized_versions(tex_file=tex_file,
                                     num_versions=num_versions,
                                     output_dir=output_dir,
                                     fix_questions=fix_questions,
                                     fix_answers=fix_answers,
                                     debug=debug)


def generate_new_masters(master_filename, num_versions=4,
                         output_dir=os.getcwd()):

    with open(master_filename, 'r') as f:
        tex = f.read()

    _cw = os.getcwd()
    os.chdir(os.path.dirname(os.path.abspath(master_filename)))
    input_files = [m.group(1) for m in re.finditer(r'\input\{(.*?)\}', tex)]
    input_files_abs = [os.path.abspath(fn) for fn in input_files]
    os.chdir(_cw)

    if num_versions <= 26:
        tags = 'abcdefghijklmnopqrstuvwxyz'
    else:
        tags = map(str, range(num_versions))

    name, ext = os.path.splitext(os.path.basename(master_filename))
    for iv in range(num_versions):
        postfix = postfix_tag(iv, num_versions)
        version_tex = copy(tex)

        for fn in input_files:
            fn_base, fn_ext = os.path.splitext(os.path.basename(fn))
            version_tex = version_tex.replace(fn, fn_base + postfix + fn_ext)

        version_master_filename = os.path.join(output_dir, name + postfix + ext)
        with open(version_master_filename, 'w') as f:
            f.write(version_tex)
        print(output_dir)
        print('"%s" created' % version_master_filename)
    return input_files_abs


if __name__ == '__main__':
    import argparse
    args = argparse.ArgumentParser()
    args.add_argument('tex_files', nargs='+',
                      help="The TeX file(s) to randomize (wildcards allowed).")
    args.add_argument('-n', '--num_versions', default=4,
                      type=int, help="The number of versions to generate.")
    args.add_argument('-o', '--output_dir', default=os.getcwd(),
                      help="directory to store output.")
    args.add_argument('-q', '--fix_questions', default=False,
                      action='store_false',
                      help="Invoke to prevent randomization of questions.")
    args.add_argument('-a', '--fix_answers', default=False,
                      action='store_true',
                      help="Invoke to prevent randomization the answers.")
    args.add_argument('-m', '--master', default=False,
                      action='store_true',
                      help="The input document is assumed to be a master "
                           "document. Randomized versions of `\input{}` "
                           "statements will generated to be used by generated "
                           "versions of the master.")
    args.add_argument('-d', '--debug', default=False,
                      action='store_true',
                      help="Turn on debugging output.")
    args = vars(args.parse_args())

    if args['fix_answers'] and args['fix_questions']:
        raise ValueError(
            "Invoking `-qa` fixes both questions and answers -- meaning "
            "generated versions would be identical to originals.")

    if args.pop('master'):
        assert len(args['tex_files']) == 1, \
            "If '-m' is invoked, only one master file can be input"
        master_filename = args.pop('tex_files')[0]
        input_files = generate_new_masters(master_filename,
                                           num_versions=args['num_versions'],
                                           output_dir=args['output_dir'])

        print("Randomizing:", ', '.join(input_files))
        generate_randomized_versions_multi(input_files, **args)
    else:
        print("Randomizing:", ', '.join(args['tex_files']))
        generate_randomized_versions_multi(**args)
