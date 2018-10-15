A tool for randomizing QA ordering in latex exams

Assumptions
-----------
* Assumes all questions are of the form:: latex

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
For a first time test, try:: bash

    $ python randomize.py test/section_*.tex


For more options/help:: bash

    $ python randomize.py -h


License
-------
MIT licensed (Andy Port, October 2018)