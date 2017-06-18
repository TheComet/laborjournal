\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{templates/fhnwreport}[2013/10/07 v2.0 PDF-LaTeX class for FHNW reports]
\LoadClass[11pt]{article}

\input{templates/packages.tex}
\input{templates/colors.tex}
\input{templates/lststyles.tex}
%\input{templates/pgfplotsset.tex}
\input{templates/tikzlibraries.tex}
\input{templates/geometry.tex}
\input{templates/fonts.tex}
\input{templates/title.tex}


\newcommand{\noparskip}{\parskip=\z@ \@plus\z@ \@minus\z@}
\ifx\TextAlignment\undefined
  \newcommand{\TextAlignment}{\relax}
  \parindent=0pt
\else\fi
\AtBeginDocument{\TextAlignment}
\parskip=1.6ex \@plus 0.4ex \@minus 0.4ex
\widowpenalty 10000
\clubpenalty 10000
\@clubpenalty 10000
\def\@listi{\leftmargin\leftmargini
  \parsep \z@ \@plus2\p@ \@minus\z@
  \topsep \z@ \@plus2\p@ \@minus\z@
  \itemsep\z@ \@plus2\p@ \@minus\z@}
\let\@listI\@listi
\@listi
\def\@listii{\leftmargin\leftmarginii
  \labelwidth\leftmarginii
  \advance\labelwidth-\labelsep
  \topsep \z@ \@plus2\p@  \@minus\z@
  \parsep \z@ \@plus\p@ \@minus\z@
  \itemsep \parsep}
\def\@listiii{\leftmargin\leftmarginiii
  \labelwidth\leftmarginiii
  \advance\labelwidth-\labelsep
  \topsep \z@ \@plus\p@ \@minus\z@
  \parsep \z@ \@minus\z@
  \partopsep \z@ \plus\z@ \@minus\z@
  \itemsep \topsep}
\def\@listiv {\leftmargin\leftmarginiv
  \labelwidth\leftmarginiv
  \advance\labelwidth-\labelsep}
\def\@listv  {\leftmargin\leftmarginv
  \labelwidth\leftmarginv
  \advance\labelwidth-\labelsep}
\def\@listvi {\leftmargin\leftmarginvi
  \labelwidth\leftmarginvi
  \advance\labelwidth-\labelsep}
\pagestyle{headings}
\renewcommand\section{\@startsection {section}{1}{\z@}%
  {-2.1ex \@plus -.6ex \@minus -.12ex}%
  {1.38ex \@plus.12ex}%
  {\SecFont\Large}}
\renewcommand\subsection{\@startsection{subsection}{2}{\z@}%
  {-1.95ex\@plus -.6ex \@minus -.12ex}%
  {.9ex \@plus .12ex}%
  {\SecFont\large}}
\renewcommand\subsubsection{\@startsection{subsubsection}{3}{\z@}%
  {-1.95ex\@plus -.6ex \@minus -.12ex}%
  {.9ex \@plus .12ex}%
  {\SecFont\normalsize}}
\renewcommand{\paragraph}[1]{\noindent\textbf{#1}}
\def\@seccntformat#1{\csname the#1\endcsname\quad}
\setlength\floatsep    {24\p@ \@plus 2\p@ \@minus 4\p@}
\setlength\textfloatsep{30\p@ \@plus 2\p@ \@minus 4\p@}

\endinput
%%
%% End of file `fhnwreport.cls'.
