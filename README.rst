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