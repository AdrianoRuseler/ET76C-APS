%%*******************************************************************
%%  DAELT 2017 LateX Class
%%
%%  Version 1.1 
%%
%%  Last Modification - 13/08/2016
%%
%%  Copyright 2017 
%%
%%  This work may be distributed and/or modified under the
%%  conditions of the LaTeX Project Public License, either version 1.3
%%  of this license of (at your option) any later version.
%%  The latest version of this license is in
%%    http://www.latex-project.org/lppl.txt
%%  and version 1.3 or later is part of all distributions of LaTeX
%%  version 2005/12/01 or later.
%%
%%  The Current Maintainer of this work is Adriano Ruseler.
%%*******************************************************************

%%*******************************************************************
%%  DESCRIPTION
%%
%%  Class Options
%%
%%
%%  Document Options
%%
%%*******************************************************************


\ProvidesClass{DAELT}[02/09/2017 V1.2]

\NeedsTeXFormat{LaTeX2e}

\LoadClass[10pt,twocolumn]{article}

\RequirePackage{ifthen}
\RequirePackage{setspace}
\RequirePackage{fancyhdr}
\RequirePackage[utf8x]{inputenc}
\RequirePackage[T1]{fontenc}
\RequirePackage{graphicx}
\RequirePackage{float}
\RequirePackage{subfigure}
\RequirePackage{geometry}
\RequirePackage{indentfirst}
\RequirePackage{caption}
\RequirePackage{fancybox}
\RequirePackage{fancyhdr}
\RequirePackage{lastpage}
\RequirePackage{xcolor}
\RequirePackage{amssymb}
\RequirePackage{amsfonts}
\RequirePackage{amsthm}
\RequirePackage{amsmath}
\RequirePackage{multicol}
\RequirePackage{mathptmx}
\RequirePackage{cite}
\RequirePackage{epstopdf}
\RequirePackage{comment}

\RequirePackage{multirow}
\RequirePackage{booktabs}
\RequirePackage{balance}

%*******************************************************************
\usepackage{hyperref}
\RequirePackage{datetime}
\usepackage{bookmark}
\RequirePackage{siunitx} % A comprehensive (SI) units package

%*******************************************************************
\sisetup{
    output-decimal-marker = {,},
	round-mode = places,
	round-precision = 2
}

\DeclareSIUnit \voltampere {VA} %apparent power 
\DeclareSIUnit \var {var} %volt-ampere reactive - idle power 


% --- 

%*******************************************************************
\definecolor{figcolor}{rgb}{0,0,0}  % black
\definecolor{tabcolor}{rgb}{0,0,0}  % black
\definecolor{eqncolor}{rgb}{0,0,0}  % black
\definecolor{seccolor}{rgb}{0,0,0}  % black
\definecolor{abscolor}{rgb}{0,0,0}  % black
\definecolor{linkcolor}{rgb}{0,0,0}  % black
\definecolor{citecolor}{rgb}{0,0,0}  % black
\definecolor{titlecolor}{rgb}{0,0,0}  % black
\definecolor{biocolor}{rgb}{0,0,0}  % black


%*******************************************************************
%*******************************************************************
% Options

%Padrão
\def\configlanguage{2}

\DeclareOption{english}
  {
    \def\configlanguage{1}
  }

\DeclareOption{portugues}
  {
    \def\configlanguage{2}
  }

\ProcessOptions

\ifnum \configlanguage = 1
\RequirePackage[english]{babel}
\else
\RequirePackage[brazil]{babel}
\fi

\geometry{tmargin=25mm,
	            lmargin=18mm,
	            rmargin=12mm,
	            bmargin=25mm,
	            a4paper,
		        ignoreheadfoot}%

\newcommand{\titulo}[1]{\gdef\@portuguesetitle{#1}} %


%Resumos e Abstract
\newenvironment{resumo}{\noindent\hspace*{4mm}\normalsize{\bf{\em \color{abscolor}{Resumo --}}}\normalsize\bf}{\par\rm\small\medskip\medskip}

\renewenvironment{abstract}{\noindent\hspace*{4mm}\normalsize{\bf{\em \color{abscolor}{Abstract --}}}\normalsize\bf}{\par\rm\small\medskip\medskip}

\newenvironment{keywords}{\noindent\hspace*{4mm}\normalsize{\bf{\em \color{abscolor}{Keywords --}}}\normalsize\bf}{\par\rm\small\medskip}

\newenvironment{palavraschave }{\noindent\hspace*{4mm}\normalsize{\bf{\em \color{abscolor}{Palavras-chave --}}}\normalsize\bf}{\par\rm\small\medskip\medskip}

%Seções
\setcounter{secnumdepth}{3}
\def\thesection {\Roman{section}.\hskip-7.2pt}
\def\thesubsection {\Alph{subsection}.\hskip-7.2pt}
\def\thesubsubsection {\arabic{subsubsection})\hskip-7.2pt}

\renewcommand\section{\@startsection {section}{1}{\z@}{2.0ex plus
									    0.5ex minus .2ex}{2.0ex plus 0.3ex minus .2ex}{\color{seccolor}\centering\MakeUppercase}}
\renewcommand\subsection{\@startsection{subsection}{2}{\z@}{1.8ex plus
		                                0.5ex minus .2ex}{0.2ex plus .0ex}{\color{seccolor}\it\raggedright}}
\renewcommand\subsubsection[1]{\@startsection{subsubsection}{3}{4mm}{-2.5ex plus
								       -1ex minus-.2ex}{-0.6ex}{\color{seccolor}\it\raggedright}{#1:}}



\def\maketitle{\par % \MakeUppercase 
	\begingroup %
		\twocolumn[\@maketitle]
	\endgroup %   
	\let\maketitle\relax \let\@maketitle\relax
} %

\def\@maketitle{ \centering
	{\Large \bf  {\ifnum \configlanguage = 1 { \color{titlecolor} \@title}\else  {\color{titlecolor}\@portuguesetitle} \fi}  \par} 
	\vskip 16.75pt
	{\large\@author}
	\vskip 9mm}

\def\englishtitle{ {\centering\large\bf\@title \par} \medskip\medskip }


%footnote rule
\renewcommand\footnoterule{\noindent\rule{5.075cm}{0.85pt}\vskip 6pt}

%nomenclature
\newcommand{\symbolnomenclature}[2]{\indent\parbox{16mm}{#1}{#2\par}}
\newcommand{\symboldescription}[2]{\indent\parbox{8.5mm}{#1}{- #2\par}}

%Table
\renewcommand{\thetable}{\Roman{table}}
\captionsetup[table]{labelsep = newline, labelfont=bf,  justification=centering}
\captionsetup[figure]{labelsep = period, font=small, justification=justified, singlelinecheck=off}
\addto\captionsenglish{\renewcommand{\figurename}{\color{figcolor} Fig.}}
\addto\captionsbrazil{\renewcommand{\figurename}{\color{figcolor} Fig.}}
\addto\captionsenglish{\renewcommand{\tablename}{\color{tabcolor} \bf TABLE}}
\addto\captionsbrazil{\renewcommand{\tablename}{\color{tabcolor} \bf TABELA}}
\addto\captionsenglish{\renewcommand{\refname}{ REFERENCES}}
\addto\captionsbrazil{\renewcommand{\refname}{REFER\^ENCIAS}}

% Macros for Cross-reference
\ifnum \configlanguage = 1 % english
\newcommand{\figref}[1]{{\color{figcolor}Figure~\ref{#1}}}   % Cross-reference of figures
\newcommand{\tabref}[1]{{\color{tabcolor}Table~\ref{#1}}}    % Cross-reference of tables
\newcommand{\eqnref}[1]{{\color{eqncolor}\eqref{#1}}}      % Cross-reference of equations
\newcommand{\secref}[1]{{\color{seccolor} Section~\ref{#1}}}  % Cross-reference of equations
\newcommand{\defref}[1]{{\color{seccolor} Definition~\ref{#1}}} % 
\else
\newcommand{\figref}[1]{{\color{figcolor}Figura~\ref{#1}}}   % Cross-reference of figures
\newcommand{\tabref}[1]{{\color{tabcolor}Tabela~\ref{#1}}}    % Cross-reference of tables
\newcommand{\eqnref}[1]{{\color{eqncolor}\eqref{#1}}}      % Cross-reference of equations
\newcommand{\secref}[1]{{\color{seccolor} Seção~\ref{#1}}}  % Cross-reference of equations
\newcommand{\defref}[1]{{\color{seccolor} Definição~\ref{#1}}} % 
\fi


\newcommand{\editorfootnote}[1]{\let\thefootnote\relax\footnotetext{\hspace*{-5mm} #1}}   % Editor footnote


% the copyright notice 
\providecommand{\printcopyright}{}
\newcommand{\copyrightnotice}[1]{\renewcommand{\printcopyright}{#1}}

% the journal name  
\providecommand{\printjournalname}{}
\newcommand{\journalname}[1]{\renewcommand{\printjournalname}{#1}}

% the journal date  
\providecommand{\printjournaldate}{}
\newcommand{\journaldate}[1]{\renewcommand{\printjournaldate}{#1}}


% the authors short name
\providecommand{\printshortauthorsname}{}
\newcommand{\shortauthorsname}[1]{\renewcommand{\printshortauthorsname}{#1}}


% definition of the title style:
\fancypagestyle{titlestyle}{%
	\fancyhf{} % clear all header and footer fields
    \fancyhead[L]{\printjournalname}
    \fancyhead[C]{}
    %\fancyhead[R]{\printjournaldate}
    \fancyhead[R]{\printjournaldate}
	\fancyfoot[L]{ \printcopyright}
    \fancyfoot[C]{\thepage}
%    \fancyfoot[R]{\includegraphics[width=1.5cm]{logos/SCSEP2015}}
	\renewcommand{\headrulewidth}{0.25pt}
	\renewcommand{\footrulewidth}{0pt}}

% definition of the body style:
\fancypagestyle{bodystyle}{%
	\fancyhf{} % clear all header and footer fields
    \fancyhead[L]{\printjournalname}
    \fancyhead[C]{}
    \fancyhead[R]{\printjournaldate}
	\fancyfoot[L]{\printshortauthorsname}
    \fancyfoot[C]{\thepage}
 %   \fancyfoot[R]{\includegraphics[width=1.5cm]{logos/SCSEP2015}}
	\renewcommand{\headrulewidth}{0.25pt}
	\renewcommand{\footrulewidth}{0pt}}

% Aplica o estilo de corpo
\pagestyle{bodystyle}%
%Espaçamento entre paragrafos
\setlength{\parskip}{0pt}

%indent config
\setlength\parindent{4.0mm}

%Configura espaçamento entre colunas
\setlength\columnsep{6.0mm}

%Configura espaçamento entre linhas
\renewcommand{\baselinestretch}{0.985}

%Configuração de Listas
\def\@listI{\leftmargin 7.5mm \leftmargini\parsep  \topsep 0pt  \itemsep -1.25mm \partopsep 10pt \listparindent 0pt 
	              \labelsep 4.5mm }


\setlength{\textfloatsep}{7pt} 
\setlength{\intextsep}{7pt} 
\setlength{\abovecaptionskip}{3pt}
\setlength{\belowcaptionskip}{3pt}

\setlength{\abovedisplayskip}{1cm}
\setlength{\belowdisplayskip}{1cm}


\sloppy
\hyphenpenalty=10000
\hyphenchar\font=-1

\hbadness=10000
\vbadness=\maxdimen

\newtheorem{theorem}{Theorem}
\newtheorem{acknowledgement}[theorem]{Acknowledgement}
\newtheorem{algorithm}[theorem]{Algorithm}
\newtheorem{axiom}[theorem]{Axiom}
\newtheorem{case}[theorem]{Case}
\newtheorem{claim}[theorem]{Claim}
\newtheorem{conclusion}[theorem]{Conclusion}
\newtheorem{condition}[theorem]{Condition}
\newtheorem{conjecture}[theorem]{Conjecture}
\newtheorem{corollary}[theorem]{Corollary}
\newtheorem{criterion}[theorem]{Criterion}
\newtheorem{definition}[theorem]{Definition}
\newtheorem{example}[theorem]{Example}
\newtheorem{exercise}[theorem]{Exercise}
\newtheorem{lemma}[theorem]{Lemma}
\newtheorem{notation}[theorem]{Notation}
\newtheorem{problem}[theorem]{Problem}
\newtheorem{proposition}[theorem]{Proposition}
\newtheorem{remark}[theorem]{Remark}
\newtheorem{solution}[theorem]{Solution}
\newtheorem{summary}[theorem]{Summary}
\renewenvironment{proof}[1][Proof]{\textbf{#1.} }{\ \rule{0.5em}{0.5em}}

\renewcommand\citeform[1]{[#1]}
\renewcommand\citeleft{}
\renewcommand\citeright{}


% Comandos auxiliares
 \newcommand{\showfont}{%
   (encoding: \f@encoding{},
   family: \f@family{},
   series: \f@series{},
   shape: \f@shape{},
   size: \f@size{},
baseline: \f@baselineskip{})
%tfsize: \tf@size{},
%sfsize: \sf@size{},
%sssize: \ssf@size{}
 }

% Comandos auxiliares
 \newcommand{\justshowfont}{%
    (\f@encoding{},
    \f@family{},
    \f@series{},
    \f@shape{},
    \f@size{},
 \f@baselineskip{})
%tfsize: \tf@size{},
%sfsize: \sf@size{},
%sssize: \ssf@size{}
 }


\AtBeginDocument{
	
}

\makeatletter
\renewenvironment{thebibliography}[1]
     {\section*{\refname}%
      \addcontentsline{toc}{section}{\refname}%
      \@mkboth{\MakeUppercase\refname}{\MakeUppercase\refname}%
      \footnotesize\vskip 0.3\baselineskip plus 0.1\baselineskip minus 0.1\baselineskip%
      \balance
      \list{\@biblabel{\@arabic\c@enumiv}}%
           {\settowidth\labelwidth{\@biblabel{#1}}%
            \leftmargin\labelwidth
            \advance\leftmargin\labelsep
            \@openbib@code
            \usecounter{enumiv}%
            \let\p@enumiv\@empty
            \renewcommand\theenumiv{\@arabic\c@enumiv}}%
      \sloppy
      \clubpenalty4000
      \@clubpenalty \clubpenalty
      \widowpenalty4000%
      \sfcode`\.\@m}
     {\def\@noitemerr
       {\@latex@warning{Empty `thebibliography' environment}}%
      \endlist}
\makeatother


\makeatletter
\newenvironment{biografia}[1]
    {\noindent\textbf{\color{biocolor}{\underline{#1}}},}
{\bigskip}
\makeatother

\makeatletter
\newenvironment{biography}[1]
    {\noindent\textbf{\color{biocolor}{\underline{#1}}},}
{\medskip}
%--------------------------------------------------
\makeatother



\makeatletter
\g@addto@macro\maketitle{\thispagestyle{titlestyle}}  
\makeatother

\makeatletter
\let\mytagform@=\tagform@
\def\tagform@#1{\maketag@@@{\color{eqncolor}{(\ignorespaces#1\unskip\@@italiccorr)}}\hspace{3mm}}
\renewcommand{\eqref}[1]{\textup{\mytagform@{\ref{#1}}}}
\makeatother



%%%%%%%%%%%%%%%%%%%%%%%%%%%%% End of DAELT.cls  %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% That's all folks!
