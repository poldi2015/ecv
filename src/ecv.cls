%%
%% Copyright 2006-2011 Christoph P. Neumann, Bernd Haberstumpf
%%
%% This LaTeX class provides a simple interface for creating
%% a verfy fancy Curriculum Vitae. At the moment only CVs in
%% the german language are supported.
%%
%% This file is free property; as a special exception the author
%% gives unlimited permission to copy and/or distribute it, with
%% or without modifications, as long as this notice is
%% preserved.
%%
%% This file is distributed in the hope that it will be useful,
%% but WITHOUT ANY WARRANTY, to the extent permitted by law;
%% without even the implied warranty of MERCHANTABILITY or
%% FITNESS FOR A PARTICULAR PURPOSE.
%%
%% SPECIAL THANKS to
%% Alexander von Gernler, who introduced me to the European Curriculum Vitae
%%

% \changes{v0.1}{2007/01/06}{Initial version}
% \changes{v0.2}{2009/08/25}{0.2}
% \changes{v0.3}{2011/04/18}{0.3}

\def\fileversion{0.3}
\def\filedate{2011/04/18}

\NeedsTeXFormat{LaTeX2e}

%
% Class definition
%

\ProvidesClass{ecv}[\filedate %
  \space Version \fileversion\space by %
  Christoph P.\ Neumann & Bernd Haberstumpf %
]


%
% Option definition
%

\def\ecv@lang{german}
\def\ecv@german{german}
\def\ecv@english{english}
\DeclareOption{german}{\def\ecv@lang{\ecv@german}}
\DeclareOption{english}{\def\ecv@lang{\ecv@english}}
\DeclareOption{oneside}{\PassOptionsToClass{oneside}{scrartcl}}
\DeclareOption{twoside}{\PassOptionsToClass{twoside}{scrartcl}}
\DeclareOption{selinput}{\def\ecv@selinput{1}}
\DeclareOption{empty}{\def\ecv@empty{1}}
\ProcessOptions

%
% Load base class
%



\LoadClass[a4paper,11pt]{article}

% define command to check for pdf
\RequirePackage{ifpdf}

\ifpdf
  \pdfcompresslevel=9           % compression level fortext and image;
\fi

%
% Load packages
%

% NLS
\RequirePackage[\ecv@lang]{ecvNLS}


% Provides an ifthenelse command
\RequirePackage{ifthen}


% Pagelayout
\ifpdf
  \RequirePackage[a4paper, pdftex]{geometry}
\else
  \RequirePackage[a4paper, dvips ]{geometry}
\fi


% For the table that makes the text spanning multiple pages
\RequirePackage{longtable}

% Grafix package for the portrait
\RequirePackage{pgf}

% compact listings/enumerate environments
\RequirePackage{paralist}

% Font
\RequirePackage{helvet}

% Colors for the sections
\RequirePackage{xcolor}

% Needed for the footline to redefine the footline
\RequirePackage{fancyhdr}

\ifx\ecv@empty\undefined
% Inputencoding (latin1 with euro sign)
\RequirePackage[latin9]{inputenc} % = latin1, but also with euro sign
% Better variant than inputenc:
\else
  \RequirePackage{selinput}
% SelectInputMappings seems not to be necessary? ...
% If it is used in the cls file it makes problems if used
% in a Windows environment... ?!?
%\SelectInputMappings{
%	adieresis={�},
%	germandbls={�},
%	Euro={�},
%}
\fi

% Outputencoding
\RequirePackage[T1]{fontenc}

% Font tweaking
%\RequirePackage{ae}
%\RequirePackage{aecompl}
%\RequirePackage{aeguill}
% e.g. for \textcopyleft
%\RequirePackage{textcomp}

% Output of links
\RequirePackage{url}
\ifpdf
  \RequirePackage[pdftex]{hyperref} %,pdfstartpage=9
\else
  \RequirePackage[dvips]{hyperref} %ALT: colorlinks
\fi


%
% configuration (page setup, color setup etc.)
%

% page setup
\geometry{left=30mm, right=20mm, top=20mm, bottom=15mm}

% Footer
\ifx\ecv@empty\undefined
  \pagestyle{fancy}
\else
  \pagestyle{empty}
\fi

% Color setup (for the sections)
\definecolor{ecv@ColBlue}{rgb}{0.04,0.44,0.59}   % ANPA 732-0, but darker
\definecolor{ecv@ColRed}{rgb}{0.921,0.282,0.278} % ANPA 723-0

\ClassInfo{ecv}{used language is \ecv@lang}

% This variable holds the name set with ecvName
\newcommand{\ecv@name}{}

% \begin{document} preamble
\AtBeginDocument{%
  \sffamily
  \raggedbottom
  \fancyhead{}
  \fancyfoot{}
  \renewcommand{\headrulewidth}{0pt}
  \renewcommand{\footrulewidth}{0pt}
  \fancyfoot[R]{
    \begin{minipage}{5cm}\begin{flushright}
      \footnotesize{}\textsf{\ecvPage~\thepage}
    \end{flushright}\end{minipage}
  }
  \ifthenelse{\equal{\ecv@name}{}}{
    ~
  }{
    \fancyfoot[L]{
      \begin{minipage}{6cm}
        \footnotesize{}\textsf{\ecvTitle~\ecv@name}
      \end{minipage}
    }
  }
}

% Command to layout the portrait (must be 60mmx40mm)
\newcommand\ecv@Portrait[1]{%
  %% A frame as placeholder (with  some 1mm inner padding):
  \pgfrect[stroke]{\pgfxy(6.85,0.65)}{\pgfxy(4.3,-6.3)}
  %% Actually a concrete digital image:
  \pgfdeclareimage[interpolate=true,height=60mm,width=40mm]{portrait}{#1}
  \pgfputat{\pgfxy(6.77,0.5)}{\pgfbox[left,top]{\pgfuseimage{portrait}}}
}

% This variable holds the name of the portrait image
\newcommand\ecv@img{}

% title with image
\newcommand{\ecv@Title}{%
  \ifthenelse{\equal{\ecv@img}{}}{ %
    \ecvLeft{\textsc{\LARGE{\ecvTitle}}%
      \bigskip\bigskip\bigskip%
    } & \tabularnewline %
  }{ %
    \ecvLeft{\textsc{\LARGE{\ecvTitle}}%
      \bigskip\bigskip\bigskip%
    } & \ecv@Portrait{\ecv@img} %
    \tabularnewline %
  } %
}


%
% Define new commands
%

% Hyperlink commands
\newcommand\ecvURL{\begingroup \urlstyle{sf}\Url}
\newcommand\ecvEMail{\begingroup \urlstyle{sf}\Url}
\ifpdf
  \newcommand{\ecvHyperLink}[1]{%
    \href{#1}{\ecvURL{#1}}%
  }
  \newcommand{\ecvHyperEMail}[1]{%
    \href{mailto:#1}{\ecvEMail{#1}}%
  }
  \newcommand{\ecvHttp}[1]{%
    \href{http://#1}{\ecvURL{#1}}%
  }
\else
  \newcommand{\ecvHyperLink}[1]{%
    \ecvURL{#1}%
  }
  \newcommand{\ecvHyperEMail}[1]{%
    \ecvEMail{#1}%
  }
  \newcommand{\ecvHttp}[1]{%
    \ecvURL{#1}%
  }
\fi
\hypersetup{a4paper,pdfpagelayout={SinglePage},pdfstartview={Fit}}
\hyperbaseurl{http://}


% Name

% Defines the name of the issuer for the footline
\newcommand{\ecvName}[1]{\renewcommand{\ecv@name}{#1}}

% Portrait

% Defines the image (to be used before the \begin{ecv})
% \ecvPortrait{file-name}
\newcommand{\ecvPortrait}[1]{\renewcommand\ecv@img{#1}}


% Environment for layouting the cv

% Environment that prints title and portrait
\newenvironment{ecv}{%
  \begin{longtable}{p{.32\linewidth}|p{.68\linewidth}}
  \ecv@Title
}{%
  \end{longtable}
}
% Environment that skips title and portrait
\newenvironment{ecv*}{%
  \begin{longtable}{p{.32\linewidth}|p{.68\linewidth}}
}{%
  \end{longtable}
}

% Vertical Spacing to be used in left column

% begin new row: make an (optional) spacing before a section
\newcommand{\ecvBreaksections}[0]{& \tabularnewline[6pt]}
% begin new row: make a break before a subsection
\newcommand{\ecvBreaksubsections}[0]{& \tabularnewline\smallskip}
% begin new row: make a break inside a section (for subsub grouping of entries)
\newcommand{\ecvBreakparagraphs}[0]{& \tabularnewline}

% Vertical spacing to be used inside a column

% start text on a new line
\newcommand{\ecvNewLine}[0]{\\}
% start a new paragraph
\newcommand{\ecvNewPara}[0]{\smallskip}

% Newpage

% Force a page break
\newcommand{\ecvNewPage}{
  \newpage
}
% Suggest a page break
\newcommand{\ecvPageBreak}{
  \pagebreak
}

% emphasizings text
\newcommand{\ecvBold}[2][\ecv@lang]{%
  \ifthenelse{\equal{#1}{\ecv@lang}}{%
    \textbf{#2}%
  }{}%
}

% bullets for the left column entries
\newcommand{\ecvBulleted}[1]{$\circ$ #1}
\newcommand{\ecvBulletedFirst}[1]{%
  \textcolor{ecv@ColBlue}{$\triangleright$} #1%
}

% layout primitives for left and right column

% primitve for the left column
\newcommand{\ecvLeft}[1]{%
  \parbox[t]{\linewidth}{\raggedright #1}%
}
% primitive for the right column (raggedright)
\newcommand{\ecvRight}[1]{%
  %\parbox[t]{\linewidth}{
  {\raggedright #1}%
  \tabularnewline%
}
% primitive for the right column (block)
\newcommand{\ecvRightBlock}[1]{%
  \parbox[t]{0.9\linewidth}{#1}%
  \tabularnewline%
}


% left column commands

% tag without bullet (simple left column entry)
\newcommand{\ecvTP}[2][\ecv@lang]{%
  \ifthenelse{\equal{#1}{\ecv@lang}}{%
    \ecvLeft{#2}%
  }{}%
}
\newcommand{\ecvTagPlain}[2][\ecv@lang]{\ecvTP[#1]{#2}}
% tag with first line mark (triange bullet left column entry)
\newcommand{\ecvTF}[2][\ecv@lang]{%
  \ifthenelse{\equal{#1}{\ecv@lang}}{%
    \ecvBreakparagraphs
    \smallskip
    \ecvLeft{\ecvBulletedFirst{#2}}%
  }{}%
}
\newcommand{\ecvTagFirst}[2][\ecv@lang]{\ecvTF[#1]{#2}}
% tag with first line mark (triange bullet left column entry)
% but WITHOUT the line break!
\newcommand{\ecvTI}[2][\ecv@lang]{%
  \ifthenelse{\equal{#1}{\ecv@lang}}{%
    \ecvLeft{\ecvBulletedFirst{#2}}%
  }{}%
}
\newcommand{\ecvTagIntermediate}[2][\ecv@lang]{\ecvTI[#1]{#2}}
% tag with first follow line mark (circle bullet left column entry)
\newcommand{\ecvTN}[2][\ecv@lang]{%
  \ifthenelse{\equal{#1}{\ecv@lang}}{%
    \ecvLeft{\ecvBulleted{#2}}%
  }{}%
}
\newcommand{\ecvTagNext}[2]{\ecvTN[#1]{#2}}


% right column commands

% value with raggedright layout
\newcommand{\ecvVR}[2][\ecv@lang]{%
  \ifthenelse{\equal{#1}{\ecv@lang}}{%
    \ecvRight{#2}%
  }{}%
}
\newcommand{\ecvValueRagged}[2][\ecv@lang]{\ecvVR[#1]{#2}}
% value with block layout
\newcommand{\ecvVB}[2][\ecv@lang]{%
  \ifthenelse{\equal{#1}{\ecv@lang}}{%
    \ecvRightBlock{#2}%
  }{}%
}
\newcommand{\ecvValueBlocked}[2][\ecv@lang]{\ecvVB[#1]{#2}}


% Compound commands tag+value

% Plain tag with ragged value
\newcommand{\ecvEPR}[3][\ecv@lang]{%
  \ifthenelse{\equal{#1}{\ecv@lang}}{%
    \ecvTP[#1]{#2} & \ecvVR[#1]{#3} %
  }{}%
}
\newcommand{\ecvTagPlainValueRagged}[3][\ecv@lang]{\ecvERP[#1]{#2}{#3}}
% Plain tag with blocked value
\newcommand{\ecvEPB}[3][\ecv@lang]{%
  \ifthenelse{\equal{#1}{\ecv@lang}}{%
    \ecvTP[#1]{#2} & \ecvVB[#1]{#3} %
  }{}%
}
\newcommand{\ecvTagPlainValueBlocked}[3][\ecv@lang]{\ecvERB[#1]{#2}{#3}}
% bulleted first tag with ragged value
\newcommand{\ecvEFR}[3][\ecv@lang]{%
  \ifthenelse{\equal{#1}{\ecv@lang}}{%
    \ecvTF[#1]{#2} & \ecvVR[#1]{#3} %
  }{}%
}
\newcommand{\ecvTagFirstValueRagged}[3][\ecv@lang]{\ecvEFR[#1]{#2}{#3}}
% bulleted first tag with blocked value
\newcommand{\ecvEFB}[3][\ecv@lang]{%
  \ifthenelse{\equal{#1}{\ecv@lang}}{%
    \ecvTF[#1]{#2} & \ecvVB[#1]{#3} %
  }{}%
}
\newcommand{\ecvTagFirstValueBlocked}[3][\ecv@lang]{\ecvEFB[#1]{#2}{#3}}
% bulleted intermediate tag with ragged value
\newcommand{\ecvEIR}[3][\ecv@lang]{%
  \ifthenelse{\equal{#1}{\ecv@lang}}{%
    \ecvTI[#1]{#2} & \ecvVR[#1]{#3} %
  }{}%
}
\newcommand{\ecvTagIntermediateValueRagged}[3][\ecv@lang]{\ecvEIR[#1]{#2}{#3}}
% bulleted intermediate tag with blocked value
\newcommand{\ecvEIB}[3][\ecv@lang]{%
  \ifthenelse{\equal{#1}{\ecv@lang}}{%
    \ecvTI[#1]{#2} & \ecvVB[#1]{#3} %
  }{}%
}
\newcommand{\ecvTagIntermediateValueBlocked}[3][\ecv@lang]{\ecvEIB[#1]{#2}{#3}}
\newcommand{\ecvENR}[3][\ecv@lang]{%
  \ifthenelse{\equal{#1}{\ecv@lang}}{%
    \ecvTN[#1]{#2} & \ecvVR[#1]{#3} %
  }{}%
}
\newcommand{\ecvTagNextValueRagged}[3][\ecv@lang]{\ecvENR[#1]{#2}{#3}}
% bulleted next tag with blocked value
\newcommand{\ecvENB}[3][\ecv@lang]{%
  \ifthenelse{\equal{#1}{\ecv@lang}}{%
    \ecvTN[#1]{#2} & \ecvVB[#1]{#3} %
  }{}%
}
\newcommand{\ecvTagNextValueBlocked}[3][\ecv@lang]{\ecvENB[#1]{#2}{#3}}
% value only ragged
\newcommand{\ecvOVR}[2][\ecv@lang]{%
  \ifthenelse{\equal{#1}{\ecv@lang}}{%
    & \ecvVR[#1]{#2} %
  }{}%
}
\newcommand{\ecvOnlyValueRagged}[2][\ecv@lang]{\ecvOVR[#1]{#2}}
\newcommand{\ecvOVB}[2][\ecv@lang]{%
  \ifthenelse{\equal{#1}{\ecv@lang}}{%
    & \ecvVB[#1]{#2} %
  }{}%
}
\newcommand{\ecvOnlyValueBlocked}[2][\ecv@lang]{\ecvOVB[#1]{#2}}




% Sections

% section: \ecvSection{name}
\newcommand{\ecvSec}[2][\ecv@lang]{%
  \ifthenelse{\equal{#1}{\ecv@lang}}{%
    \ecvLeft{\textsc{\Large{\textcolor{ecv@ColBlue}{#2}}} \bigskip } &%
    \tabularnewline%
  }{}%
}
\newcommand{\ecvSection}[2][\ecv@lang]{\ecvSec[#1]{#2}}
% section with breaksection: \ecvBreakSection{name}
\newcommand{\ecvBSec}[2][\ecv@lang]{%
  \ifthenelse{\equal{#1}{\ecv@lang}}{%
    \ecvBreaksections
    \ecvLeft{\textsc{\Large{\textcolor{ecv@ColBlue}{#2}}} \bigskip } &%
    \tabularnewline%
  }{}%
}
\newcommand{\ecvBreakSection}[2][\ecv@lang]{\ecvBSec[#1]{#2}}
% sub-section: \ecvSubSection{name}
\newcommand{\ecvSub}[2][\ecv@lang]{%
  \ifthenelse{\equal{#1}{\ecv@lang}}{%
    \ecvLeft{\textsc{\large{#2}}}%
    & \tabularnewline%
  }{}%
}
\newcommand{\ecvSubSection}[2][\ecv@lang]{\ecvSub[#1]{#2}}
\newcommand{\ecvBSub}[2][\ecv@lang]{%
  \ifthenelse{\equal{#1}{\ecv@lang}}{%
    \ecvBreaksubsections
    \ecvLeft{\textsc{\large{#2}}}%
    & \tabularnewline%
  }{}%
}
\newcommand{\ecvBreakSubSection}[2][\ecv@lang]{\ecvBSub[#1]{#2}}
% sub-section with a value
\newcommand{\ecvERSub}[3][\ecv@lang]{%
  \ifthenelse{\equal{#1}{\ecv@lang}}{%
    \ecvLeft{\textsc{\large{#2}}} & \ecvRight{#3}%
  }{}%
}
\newcommand{\ecvEntryRaggedSubSection}[3][\ecv@lang]{\ecvERSub[#1]{#2}{#3}}
\newcommand{\ecvBERSub}[3][\ecv@lang]{%
  \ifthenelse{\equal{#1}{\ecv@lang}}{%
    \ecvBreaksubsections
    \ecvLeft{\textsc{\large{#2}}} & \ecvRight{#3}%
  }{}%
}
\newcommand{\ecvBreakEntryRaggedSubSection}[3][\ecv@lang]{\ecvBERSub[#1]{#2}{#3}}
% sub-section with a value
\newcommand{\ecvEBSub}[3][\ecv@lang]{%
  \ifthenelse{\equal{#1}{\ecv@lang}}{%
    \ecvLeft{\textsc{\large{#2}}} & \ecvRightBlock{#3}%
  }{}%
}
\newcommand{\ecvEntryBlockedSubSection}[3][\ecv@lang]{\ecvEBSub[#1]{#2}{#3}}
\newcommand{\ecvBEBSub}[3][\ecv@lang]{%
  \ifthenelse{\equal{#1}{\ecv@lang}}{%
    \ecvBreaksubsections
    \ecvLeft{\textsc{\large{#2}}} & \ecvRightBlock{#3}%
  }{}%
}
\newcommand{\ecvBreakEntryBlockedSubSection}[3][\ecv@lang]{\ecvBEBSub[#1]{#2}{#3}}




% Signature

% \ecvSignature{name}{town}
\newcommand{\ecvSig}[2]{ %
  \vspace{1cm}
  \noindent
  #2, \today \\[18pt]

  #1
}
\newcommand{\ecvSignature}[2]{\ecvSig{#1}{#2}}
\endinput
%%
%% End of file `ecv.cls'.