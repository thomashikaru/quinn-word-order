# Word Order LMs

## Setup
- Install kenlm and dependencies
- Download raw language data
- Fill in the shell commands under rule make_dataset that will create a counterfactual dataset, given a language and a variant

## Usage
- Use Snakemake to request a file, e.g. `results/ngram/en/reverse/summary.txt`
- Use `snakemake --dag ngram_pipeline | dot -Tpdf > dag.pdf` to create a DAG of the pipeline and save it as PDF
- Run `snakemake ngram_pipeline` to run the entire pipeline