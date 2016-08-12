# singularity-manuscript

1. [install singularity](http://singularity.lbl.gov/#install)
1. clone and enter this repository
  - `git clone https://github.com/cjprybol/singularity-manuscript.git && cd singularity-manuscript/Src`
1. download the singularity container used to perform the analysis
  - `wget https://stanfordmedicine.box.com/shared/static/jegnshtg4veiyc7w81ugm1s4w9b5tedu.img -O singularity-manuscript.img`
1. run the tests for yourself

```
OUT_DIR="../LaunchTimes"
if [ ! -d $OUT_DIR ]; do
  mkdir $OUT_DIR
done

touch $OUT_DIR/python.txt

for i in 1..10; do
  time python3 100_random_numbers.py >> $OUT_DIR/python_times.txt
done

touch $OUT_DIR/R.txt

for i in 1..10; do
  time Rscript 100_random_numbers.R >> $OUT_DIR/R.txt
done

singularity exec python3 generate_plots.py```
