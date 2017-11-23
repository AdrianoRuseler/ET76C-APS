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
\RequirePackage{listings}

%*******************************************************************
\RequirePackage{hyperref}
\RequirePackage{datetime}
\RequirePackage{bookmark}
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


\definecolor{mygreen}{rgb}{0,0.6,0}
\definecolor{mygray}{rgb}{0.5,0.5,0.5}
\definecolor{mymauve}{rgb}{0.58,0,0.82}

\lstset{ %
	aboveskip=3mm,
	belowskip=3mm,
	backgroundcolor=\color{white},   % choose the background color; you must add \usepackage{color} or \usepackage{xcolor}
	basicstyle={\small\ttfamily},    % the size of the fonts that are used for the code
	breakatwhitespace=true,          % sets if automatic breaks should only happen at whitespace
	breaklines=true,                 % sets automatic line breaking
	captionpos=t,                    % sets the caption-position to bottom
	commentstyle=\color{mygreen},    % comment style
	columns=flexible,
	deletekeywords={...},            % if you want to delete keywords from the given language
	escapeinside={\%*}{*)},          % if you want to add LaTeX within your code
	extendedchars=true,              % lets you use non-ASCII characters; for 8-bits encodings only, does not work with UTF-8
	frame=tb,                        % adds a frame around the code
	keepspaces=true,                 % keeps spaces in text, useful for keeping indentation of code (possibly needs columns=flexible)
	keywordstyle=\color{blue},       % keyword style
	language=C,                      % the language of the code
	morekeywords={*,...},            % if you want to add more keywords to the set
	numbers=none,                    % where to put the line-numbers; possible values are (none, left, right)
	numbersep=5pt,                   % how far the line-numbers are from the code
	numberstyle=\tiny\color{mygray}, % the style that is used for the line-numbers
	rulecolor=\color{black},         % if not set, the frame-color may be changed on line-breaks within not-black text (e.g. comments (green here))
	showspaces=false,                % show spaces everywhere adding particular underscores; it overrides 'showstringspaces'
	showstringspaces=false,          % underline spaces within strings only
	showtabs=false,                  % show tabs within strings adding particular underscores
	stepnumber=2,                    % the step between two line-numbers. If it's 1, each line will be numbered
	stringstyle=\color{mymauve},     % string literal style
	tabsize=3,                       % sets default tabsize to 3 spaces
	texcl=true,						 % Permite o uso de acentuação no código
	title=\lstname                   % show the filename of files included with \lstinputlisting; also try caption instead of title
}

%By default, listings does not support multi-byte encoding for source code. The extendedchar option only works for 8-bits encodings such as latin1.
%
%To handle UTF-8, you should tell listings how to interpret the special characters by defining them like so
\lstset{literate=	
	{á}{{\'a}}1 {é}{{\'e}}1 {í}{{\'i}}1 {ó}{{\'o}}1 {ú}{{\'u}}1
	{Á}{{\'A}}1 {É}{{\'E}}1 {Í}{{\'I}}1 {Ó}{{\'O}}1 {Ú}{{\'U}}1
	{à}{{\`a}}1 {è}{{\`e}}1 {ì}{{\`i}}1 {ò}{{\`o}}1 {ù}{{\`u}}1
	{À}{{\`A}}1 {È}{{\'E}}1 {Ì}{{\`I}}1 {Ò}{{\`O}}1 {Ù}{{\`U}}1
	{ä}{{\"a}}1 {ë}{{\"e}}1 {ï}{{\"i}}1 {ö}{{\"o}}1 {ü}{{\"u}}1
	{Ä}{{\"A}}1 {Ë}{{\"E}}1 {Ï}{{\"I}}1 {Ö}{{\"O}}1 {Ü}{{\"U}}1
	{â}{{\^a}}1 {ê}{{\^e}}1 {î}{{\^i}}1 {ô}{{\^o}}1 {û}{{\^u}}1
	{Â}{{\^A}}1 {Ê}{{\^E}}1 {Î}{{\^I}}1 {Ô}{{\^O}}1 {Û}{{\^U}}1	 
	{œ}{{\oe}}1 {Œ}{{\OE}}1 {æ}{{\ae}}1 {Æ}{{\AE}}1 {ß}{{\ss}}1
	{ű}{{\H{u}}}1 {Ű}{{\H{U}}}1 {ő}{{\H{o}}}1 {Ő}{{\H{O}}}1
	{ç}{{\c c}}1 {Ç}{{\c C}}1 {ø}{{\o}}1 {å}{{\r a}}1 {Å}{{\r A}}1
	{€}{{\EUR}}1 {£}{{\pounds}}1 {ã}{{\~a}}1 {õ}{{\~o}}1 {Ã}{{\~A}}1 {Õ}{{\~O}}1	
}

\renewcommand{\lstlistingname}{Código--fonte}% Listing -> Codigo fonte


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
