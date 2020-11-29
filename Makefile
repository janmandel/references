STYLE=ametsoc
STYLE=splncs04
PREREQ=bib2pdf Makefile

default: sync

add:
	-cvs add -kb */*.pdf
	cvs commit -m sync
	#make squash
	#make export

sync:   bddc-pdf geo-pdf other-pdf slides-pdf epi-pdf bigdata-pdf ml-pdf 
	git pull
	-git commit -a -m 'references sync'
	git push
	-cvs add -kb */*.pdf
	cvs commit -m sync
	make squash
	make export

export:
	-ssh repo ssh math cvsroot/web

squash:
	-cvs-squash {geo,other,epi,slides,bigdata,ml,bddc}.pdf

geo-pdf:
	make pdf INFILE=geo

bigdata-pdf:
	make pdf INFILE=bigdata

epi-pdf:
	make pdf INFILE=epi

other-pdf:
	make pdf INFILE=other

ml-pdf:
	make pdf INFILE=ml

slides-pdf:
	make pdf INFILE=slides

bddc-pdf:
	make pdf INFILE=bddc



pdf:	
	make $(INFILE).pdf

$(INFILE).pdf: $(INFILE).bib $(PREREQ) 
	rm -f $(INFILE).{tex,bbl,log,blg,aux}
	./bib2pdf $(INFILE).bib $(STYLE)
	rm -f $(INFILE).{tex,bbl,log,blg,aux}

clean:
	rm *.{pdf,tex,bbl,log}
