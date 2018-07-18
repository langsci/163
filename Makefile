SOURCE=  $(wildcard *.tex)

.SUFFIXES: .tex


%.pdf: %.tex $(SOURCE)
	xelatex -no-pdf -interaction=nonstopmode $* |grep -v math
	xelatex -no-pdf -interaction=nonstopmode $* 
	xelatex -no-pdf -interaction=nonstopmode $*
	correct-index
	\rm $*.adx
	authorindex -i -p $*.aux > $*.adx
	sed -e 's/}{/|hyperpage}{/g' $*.adx > $*.adx.hyp
	makeindex -gs index.format-plus -o $*.and $*.adx.hyp
	makeindex -gs index.format -o $*.lnd $*.ldx
	makeindex -gs index.format -o $*.snd $*.sdx
	xelatex $* | egrep -v 'math|PDFDocEncod|microtype' |egrep 'Warning|label|aux'


all: phrasal-lfg-langsci.pdf 




${HOME}/Sites/Pub/phrasal-lfg.pdf: phrasal-lfg.pdf 
	cp -p $? ${HOME}/Sites/Pub/


${HOME}/Sites/Pub/phrasal-lfg-headlex2016.pdf: phrasal-lfg-headlex2016.pdf 
	cp -p $? ${HOME}/Sites/Pub/



o-public: ${HOME}/Sites/Pub/phrasal-lfg.pdf
	scp -p $? home.hpsg.fu-berlin.de:/home/stefan/public_html/Pub/


#	svn commit -m "automatic commit"


clean:
	find . -name \*\.bak -exec \rm {} \;
	find . -name \*~ -exec \rm {} \;
	rm -f *.bak *.toc *.bbl *.blg *~ *.log *.aux *.*pk *.out *.tmp *.cut *.bbl.old


realclean: clean
	rm -f *.dvi *.ps *.pdf
