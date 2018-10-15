% exam3.cls
%
% Based on testpoints.tex
%
% $Log: exam.cls,v $
% Revision 1.4  2006/09/07 07:15:45  elm
%
% Now using mathptmx instead of mathptm.
%
% Revision 1.3  2005/12/20 18:15:54  elm
% *** empty log message ***
%
% Revision 1.2  2005/03/02 22:53:27  elm
% More cleanup for exam.cls.
%
% Revision 1.1  2003/07/30 21:45:02  elm
% Class for writing exams.
%
%------------------------------------------------------------------
% PROBLEM, PART, AND POINT COUNTING...

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{exam3}

\RequirePackage{times,mathptmx,latexsym,fullpage}
\RequirePackage{ifthen,graphicx,xspace,framed}
\RequirePackage{verbatim}
\RequirePackage{pagecounting}
\RequirePackage{lastpage}
\RequirePackage[absolute]{textpos}

\newboolean{exam@solutions}
\setboolean{exam@solutions}{false}
\newboolean{exam@choiceboxes}
\setboolean{exam@choiceboxes}{true}
\newboolean{exam@pointboxes}
\setboolean{exam@pointboxes}{false}
\newboolean{exam@leavespace}
\setboolean{exam@leavespace}{true}
\newboolean{exam@nameheading}
\setboolean{exam@nameheading}{true}

\DeclareOption{solutions}{\setboolean{exam@solutions}{true}}
\DeclareOption{answerboxes}{\setboolean{exam@choiceboxes}{true}}
\DeclareOption{noanswerboxes}{\setboolean{exam@choiceboxes}{false}}
\DeclareOption{choiceboxes}{\setboolean{exam@choiceboxes}{true}}
\DeclareOption{nochoiceboxes}{\setboolean{exam@choiceboxes}{false}}
\DeclareOption{pointboxes}{\setboolean{exam@pointboxes}{true}}
\DeclareOption{leavespace}{\setboolean{exam@leavespace}{true}}
\DeclareOption{noleavespace}{\setboolean{exam@leavespace}{false}}
\DeclareOption{nameheading}{\setboolean{exam@nameheading}{true}}
\DeclareOption{nonameheading}{\setboolean{exam@nameheading}{false}}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\PassOptionsToClass{letterpaper}{article}
\ProcessOptions
\LoadClass[letterpaper]{article}

% Set up lengths for various things.  Turn off paragraph indenting.
\setlength{\parindent}{0pt}
\setlength{\parskip}{0.5ex plus 0.5ex minus 0.5ex}

\setlength{\topmargin}{-0.5in}
\setlength{\headsep}{0.25in}
\setlength{\headheight}{0.25in}
\setlength{\textheight}{9.1in}
\setlength{\oddsidemargin}{-0.25in}
\setlength{\evensidemargin}{-0.25in}
\setlength{\footskip}{0.4in}
\setlength{\textwidth}{7in}

\newlength{\exam@answerwidth}
\setlength{\exam@answerwidth}{6.5in}
\newlength{\exam@problemwidth}
\setlength{\exam@problemwidth}{\textwidth}
\addtolength{\exam@problemwidth}{-10pt}

% Settings for the textpos module
\setlength{\TPHorizModule}{1in}
\setlength{\TPVertModule}{1in}

\newenvironment{scorebox}{
  \begin{textblock}{1.5}(6.8,0.25)
    \ifthenelse{\boolean{exam@solutions}}
               {\sffamily\fontsize{6}{8pt}\selectfont}
               {\sffamily\fontsize{13}{18pt}\selectfont}
               \begin{minipage}{1.5in}
}{
               \end{minipage}
  \end{textblock}
}

\renewcommand{\maketitle}{
  \begin{center}
  {\Large \@title} \\
  \vspace{14pt}
  {\large \@date}
  \end{center}
}

\newcommand{\exam@instrname}{ANSWERS}
\newcommand{\exam@instremail}{nobody}
\newcommand{\exam@emaildomain}{ucsc.edu}
\newcommand{\exam@pagename}{Page}
\newcommand{\exam@account}{Account:}
\newcommand{\instructorname}[1]{\renewcommand{\exam@instrname}{#1}}
\newcommand{\instructoremail}[1]{\renewcommand{\exam@instremail}{#1}}
\newcommand{\emaildomain}[1]{\renewcommand{\exam@emaildomain}{#1}}
\newcommand{\exampagename}[1]{\renewcommand{\exam@pagename}{#1}}
\newcommand{\examaccount}[1]{\renewcommand{\exam@account}{#1}}
\newcommand{\examtotalpages}{\pageref{LastPage}}
\newcommand{\examsection}[1]{\centerline{\fbox{\Large\textbf{#1}}} \vspace{0.15in}}

\renewcommand{\ps@headings}{
  \renewcommand{\@oddhead}{
    \ifthenelse{\boolean{exam@nameheading}}{
      \parbox[t]{2.8in}{{\fontsize{13}{15pt}\selectfont Name:}
        \underline{
          \makebox[2.3in]{
            \ifthenelse{\boolean{exam@solutions}}{\textbf{\exam@instrname}}{}}}
      }
      \parbox[t]{3.25in}{{\fontsize{13}{15pt}\selectfont \exam@account}
        \underline{
          \makebox[0.95in]{
            \ifthenelse{\boolean{exam@solutions}}{\textbf{\exam@instremail}}{}}
        } {\fontsize{13}{15pt}\selectfont @\exam@emaildomain}
      }
    }{}
  }
  \renewcommand{\@evenhead}{\@oddhead}
  \renewcommand{\@oddfoot}{
    \begin{tabular*}{\textwidth}{l@{\extracolsep{\fill}}c@{\extracolsep{\fill}}r}
    {\small \@title}  & {\large \exam@pagename~\textbf{\thepage}~of~\textbf{\examtotalpages}} & {\small \@date}
    \end{tabular*}
  }
  \renewcommand{\@evenfoot}{\@oddfoot}
}

\pagestyle{headings}

\newlength{\exam@cboxwidth}
\settowidth{\exam@cboxwidth}{$\bigcirc$~~}
\newcommand{\exam@amark}{\ifthenelse{\boolean{exam@solutions}}{\makebox[0pt][l]{\hspace*{2pt}\textbf{\ifthenelse{\boolean{exam@choiceboxes}}{$\textsf{x}$}{$\Longrightarrow$}}}}{}}
\newcommand{\exam@cbox}{\makebox[\exam@cboxwidth][l]{\ifthenelse{\boolean{exam@choiceboxes}}{$\bigcirc$~~}{}}}

\newcommand{\correct}{\addtocounter{mchoice}{1}\item[\exam@amark\exam@cbox\Alph{mchoice}.\hfill]}


\newcommand{\xtem}{\correct}
\newcommand{\choice}{\item}

\newcounter{mchoice}
\newenvironment{mchoice}{
  \begin{list}
    {\exam@cbox\Alph{mchoice}.\hfill}
    {\usecounter{mchoice}
      \setlength{\topsep}{0ex}
      \setlength{\parskip}{0ex}
      \setlength{\leftmargin}{0.65in}
      \settowidth{\labelwidth}{{\exam@cbox}M.}
      \settowidth{\labelsep}{N}
      \setlength{\parsep}{0ex}
      \setlength{\itemsep}{0ex}
    }
}{
  \end{list}
}

\newcommand{\pointboxes}{\setboolean{exam@pointboxes}{true}}
\newcommand{\nopointboxes}{\setboolean{exam@pointboxes}{false}}

% Create the problem number counter.  Initialize to zero.
\newcounter{problemnum}

% Specify that problems should be labeled with arabic numerals.
\renewcommand{\theproblemnum}{\arabic{problemnum}}


% Create the part-within-a-problem counter, "within" the problem counter.
% This counter resets to zero automatically every time the PROBLEMNUM counter
% is incremented.
\newcounter{partnum}[problemnum]

% Specify that parts should be labeled with lowercase letters.
\renewcommand{\thepartnum}{\alph{partnum}}

% Make a counter to keep track of total points assigned to problems...
\newcounter{totalpoints}

% Make counters to keep track of points for parts...
\newcounter{curprobpts}		% Points assigned for the problem as a whole.
\newcounter{totalparts}		% Total points assigned to the various parts.

%---------------------------------------------------------------------------


% The \problem environment first checks the information about the previous
% problem.  If no parts appeared (or if they were all assigned zero points,
% then it increments TOTALPOINTS directly from CURPROBPTS, the points assigned
% to the last problem as a whole.  If the last problem did contain parts, it
% checks to make sure that their point values total up to the correct sum.
% It then puts the problem number on the page, along with the points assigned
% to it.
\newcommand{\exam@ptword}{}
\newsavebox{\exam@problembox}
% Set a problem in a minipage so it's not split across pages.
\newenvironment{problem}[2][]{
% Reset counters.
  \setcounter{curprobpts}{#2}
  \setcounter{totalparts}{0}
  \renewcommand{\exam@ptword}{point\ifthenelse{\value{curprobpts} = 1}{}{s}}
  \ifthenelse{\value{curprobpts} < 0}{}{\vspace{1ex}}
  \begin{lrbox}{\exam@problembox}
    \par\noindent
    \begin{minipage}[t]{\exam@problemwidth}
      \begin{list}
        {\large \theproblemnum.\hfill}  % Problem number
        {\setlength{\topsep}{0ex}
          \settowidth{\labelwidth}{\large 00.}
          \settowidth{\labelsep}{N}
          \setlength{\itemindent}{0pt}
          \setlength{\listparindent}{0in}
          \setlength{\parsep}{0.5ex}
          \setlength{\partopsep}{0pt}
          \setlength{\leftmargin}{0.25in}
        }
% STATEMENTS TO BE EXECUTED WHEN A PROBLEM IS BEGUN:
%
% Increment the problem number counter, and set the current \ref value to that
% number.
  \ifthenelse{\value{curprobpts} < 0}{}{\refstepcounter{problemnum}}
% Now put in the "announcement" on the page.
  \item
  \ifthenelse{\boolean{exam@pointboxes}}
    {
      \begin{tabular*}{\exam@answerwidth}{@{}l@{\extracolsep\fill}r@{}}
      \textbf{\large #1} &
      \fbox{Score: \rule{0.75in}{0mm}/\arabic{curprobpts} \exam@ptword} \\
      \end{tabular*}
      \par\noindent
    }{
      \emph{(\arabic{curprobpts} \exam@ptword)}
      \textbf{\large #1}
    }
}{
% STATEMENTS TO BE EXECUTED WHEN AN PROBLEM IS ENDED:
%
% If no parts to problem, then increment TOTALPOINTS for the entire
% problem at once.
  \ifthenelse{\value{curprobpts} < 0}{
    % Undo the newpart commands that added to points.
    \ifthenelse{\value{totalparts} = 0}{}{
      \addtocounter{totalpoints}{\value{curprobpts}}
    }
  }{
    \ifthenelse{\value{totalparts} = 0}{
      \addtocounter{totalpoints}{\value{curprobpts}}	% Add pts to total.
    }{
      % If there were parts for the problem, then check to make sure they total up
      % to the same number of points that the problem is worth. Issue a warning
      % if not.
      \ifthenelse{\value{totalparts} = \value{curprobpts}}{
      }{
        \typeout{}
        \typeout{!!!!!!!   POINT ACCOUNTING ERROR   !!!!!!!!}
        \typeout{PROBLEM [\theproblemnum] WAS ALLOCATED \arabic{curprobpts} POINTS,}
        \typeout{BUT CONTAINS PARTS TOTALLING \arabic{totalparts} POINTS!}
        \typeout{}
      }
    }
  }
  \end{list}\end{minipage}\end{lrbox}
  \ifthenelse{\value{curprobpts} < 0}{}{\usebox{\exam@problembox}}{}
}

%---------------------------------------------------------------------------

% The \newpart command increments the part counter and displays an appropriate
% lowercase letter to mark the part.  It adds points to the point counter
% immediately.  If 0 points are specified, no point announcement is made.
% Otherwise, the announcement is in scriptsize italics.

\newlength{\exam@templen}
\newcommand{\newpart}[1]{
  \refstepcounter{partnum}	% Set the current \ref value to the part number.
%\hspace{0.20in}		
%
% If points are to be printed for this problem (signaled by point value > 0),
% then put them in in scriptsize italics.
  \setlength{\exam@templen}{\parindent}
  \setlength{\parindent}{-0.25in}
  \indent\makebox[0.25in][l]{\textbf{\thepartnum.}}\ifthenelse{#1 > 0}{(\textit{#1 point\ifthenelse{#1 = 1}{}{s}})}{}
  \setlength{\parindent}{\exam@templen}
  \addtocounter{totalparts}{#1}	 % Add points to totalparts for this problem.
  \addtocounter{totalpoints}{#1} % Add points to total for entire test.
}


%---------------------------------------------------------------------------

\newenvironment{testonly}{
  \begin{lrbox}{\exam@answerbox}
    \begin{minipage}{\textwidth}
}{
    \end{minipage}
  \end{lrbox}
  \ifthenelse{\boolean{exam@solutions}}{}{\usebox{\exam@answerbox}}
}

\newenvironment{solutionsonly}{
  \begin{lrbox}{\exam@answerbox}
    \begin{minipage}{\textwidth}
}{
    \end{minipage}
  \end{lrbox}
  \ifthenelse{\boolean{exam@solutions}}{\usebox{\exam@answerbox}}{}
}
\newcommand{\iftestonly}[1]{\ifthenelse{\boolean{exam@solutions}}{}{#1}}

\newsavebox{\exam@answerbox}
\newcommand{\exam@answerheight}{0}

\newenvironment{answer}[1]{
  \renewcommand{\exam@answerheight}{#1}

  \begin{center}
    \begin{lrbox}{\exam@answerbox}
      \begin{minipage}[t][\exam@answerheight][t]{\exam@answerwidth}
        \noindent\rule{\exam@answerwidth}{0mm}\par
        \small
}{
      \end{minipage}
    \end{lrbox}
    \ifthenelse{\boolean{exam@solutions}}{
      \fbox{\usebox{\exam@answerbox}}
    }{
      \ifthenelse{\boolean{exam@leavespace}}{\vspace*{\exam@answerheight}}{}
    }
  \end{center}
}

\newcommand{\explanation}[1]{\ifthenelse{\boolean{exam@solutions}}{\textit{#1}}{}}

% Just in case you want to skip some numbers in your test...

\newcommand{\skipproblem}[1]{\addtocounter{problemnum}{#1}}
\newcommand{\setproblem}[1]{\setcounter{problemnum}{#1}}
\newcommand{\resetproblem}{\setproblem{0}}


%---------------------------------------------------------------------------


% The \showpoints command simply gives a count of the total points read in up to
% the location at which the command is placed.  Typically, one places one
% \showpoints command at the end of the latex file, just prior to the
% \end{document} command.  It can appear elsewhere, however.

\newcommand{\showpoints}
{
\typeout{}  
\typeout{====> A TOTAL OF \arabic{totalpoints} POINTS WERE READ.}
\typeout{}
}


%---------------------------------------------------------------------------

