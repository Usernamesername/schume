
all: schumec TeX/Compiler.pdf TeX/Compiler.ps

schumec: Main.hs Compiler.lhs Syntax/Abs.hs
	ghc --make Syntax/Abs.hs Syntax/Par.hs Syntax/Lex.hs
	ghc --make -Wall Main.hs Compiler.lhs -o schumec

clean:
	rm -f *.o *.hi schumec
	rm -rf Syntax
	rm -rf TeX

Syntax/Abs.hs: Syntax.cf
	bnfc -d Syntax.cf
	alex -g Syntax/Lex.x
	happy -gca Syntax/Par.y

TeX/Compiler.pdf: Document.lhs Compiler.lhs
	mkdir -p TeX
	lhs2TeX -o TeX/Compiler.tex Document.lhs
	( cd TeX ; pdflatex Compiler.tex ; pdflatex Compiler.tex ; cd .. )

TeX/Compiler.ps: TeX/Compiler.pdf
	( cd TeX ; latex Compiler.tex ; latex Compiler.tex ; dvips Compiler ; cd .. )
