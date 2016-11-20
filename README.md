# singularity-testing

1. [install singularity](http://singularity.lbl.gov/#install)
1. clone and enter this repository
  - `git clone https://github.com/cjprybol/singularity-testing.git && cd singularity-testing/Src`, or
  - `git clone git@github.com:cjprybol/singularity-testing.git && cd singularity-testing/Src`
1. download the singularity container used to perform the analysis
  - `wget https://stanfordmedicine.box.com/shared/static/jegnshtg4veiyc7w81ugm1s4w9b5tedu.img -O singularity-testing.img`
1. run the tests in `/Src` in numeric order

generate PDF with `pandoc --bibliography=Untitled.bib --latex-engine=xelatex manuscript.md -o manuscript.pdf`
