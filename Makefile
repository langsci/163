SOURCE=  $(wildcard *.tex)
SOURCE_ALL=  $(wildcard *.tex) phrasal-lfg.bib
BIBTOOL = bibtool-Mac

.SUFFIXES: .tex


%.pdf: %.tex $(SOURCE)
	xelatex -no-pdf -interaction=nonstopmode $* |grep -v math
	biber $*
	xelatex -no-pdf -interaction=nonstopmode $* 
	biber $*
	xelatex -no-pdf -interaction=nonstopmode $*
	correct-index
	sed -i.backup 's/hyperindexformat{\\\(infn {[0-9]*\)}/\1/' *.sdx # ordering of references to footnotes
	sed -i.backup 's/hyperindexformat{\\\(infn {[0-9]*\)}/\1/' *.adx
	sed -i.backup 's/hyperindexformat{\\\(infn {[0-9]*\)}/\1/' *.ldx
	sed -i.backup 's/\\protect \\active@dq \\dq@prtct {=}/"=/g' *.adx
	sed -i.backup 's/{\\O }/Oe/' *.adx
	python3 fixindex.py
	mv $*mod.adx $*.adx
	makeindex -gs index.format-plus -o $*.and $*.adx
	makeindex -gs index.format -o $*.lnd $*.ldx
	makeindex -gs index.format -o $*.snd $*.sdx
	xelatex $* | egrep -v 'math|PDFDocEncod|microtype' |egrep 'Warning|label|aux'


all: phrasal-lfg-langsci.pdf 


#create a png of the cover
cover: FORCE
	convert phrasal-lfg-langsci.pdf\[0\] -quality 100 -background white -alpha remove -bordercolor "#999999" -border 2  cover.png
	cp cover.png googlebooks_frontcover.png
	convert -geometry 50x50% cover.png covertwitter.png
	display cover.png

${HOME}/Sites/Pub/phrasal-lfg-langsci.pdf: phrasal-lfg-langsci.pdf 
	cp -p $? ${HOME}/Sites/Pub/


${HOME}/Sites/Pub/phrasal-lfg-headlex2016.pdf: phrasal-lfg-headlex2016.pdf 
	cp -p $? ${HOME}/Sites/Pub/



o-public: ${HOME}/Sites/Pub/phrasal-lfg-langsci.pdf
	scp -p $? hpsg.hu-berlin.de:/home/stefan/public_html/Pub/


#	svn commit -m "automatic commit"

bib: phrasal-lfg.bib

phrasal-lfg.bib: ../../Bibliographien/biblio.bib
	xelatex -no-pdf -interaction=nonstopmode bib-creation 
	biber -m=1 bib-creation.bcf       # `--mincrossref | -m 1` produces a .bbl with all the references 
	bbl2nocite bib-creation tmpfile
	xelatex -no-pdf -interaction=nonstopmode bib-creation 
	biber --output_format=bibtex bib-creation.bcf -O phrasal-lfg.bib

#	biber bib-creation 
#	biber --output_format=bibtex --output_resolve bib-creation.bcf -O gt.bib	

clean:
	find . -name \*\.bak -exec \rm {} \;
	find . -name \*~ -exec \rm {} \;
	rm -f *.bak *.toc *.bbl *.blg *~ *.log *.aux *.*pk *.out *.tmp *.cut *.bbl.old	*.and *.glg *.glo *.gls *.657pk *.adx.hyp *.bbl.old *.ldx *.lnd *.rdx *.sdx *.snd *.wdx \
	*.wdv *.xdv chapters/*.aux *.for *.aux.copy *-blx.bib *.auxlock *.bcf *.mw *.run.xml *.backup _autidx_.bib



realclean: clean
	rm -f *.dvi *.ps *.pdf


FORCE:
