LANGS = ["en", "ru", "jp"]
VARIANTS = ["real", "reverse", "random"]

rule make_dataset:
    input:
    output:
        f"data/counterfactual/{{lang}}/{{variant}}/train.txt",
        f"data/counterfactual/{{lang}}/{{variant}}/test.txt",
    shell:
        """
        """

rule train_ngram_model:
    input:
        f"data/counterfactual/{{lang}}/{{variant}}/train.txt"
    output:
        f"data/models/ngram/{{lang}}/{{variant}}/model.binary"
    shell:
        f"""
        mkdir -p data/models/ngram/{{wildcards.lang}}/{{wildcards.variant}}
        cat data/counterfactual/{{wildcards.lang}}/{{wildcards.variant}}/train.txt | \
            kenlm/build/bin/lmplz -S 5G -o 5 --skip_symbols > \
            data/models/ngram/{{wildcards.lang}}/{{wildcards.variant}}/model.arpa
        kenlm/build/bin/build_binary \
            data/models/ngram/{{wildcards.lang}}/{{wildcards.variant}}/model.arpa \
            data/models/ngram/{{wildcards.lang}}/{{wildcards.variant}}/model.binary
        """

rule get_ngram_surprisals:
    input: 
        f"data/models/ngram/{{lang}}/{{variant}}/model.binary",
        f"data/counterfactual/{{lang}}/{{variant}}/test.txt",
    output:
        f"results/ngram/{{lang}}/{{variant}}/summary.txt",
    shell:
        f"""
        mkdir -p results/ngram/{{wildcards.lang}}/{{wildcards.variant}}
        kenlm/build/bin/query -v summary data/models/ngram/{{wildcards.lang}}.binary < \
            data/counterfactual/{{wildcards.lang}}/{{wildcards.variant}}/test.txt > \
            results/ngram/{{wildcards.lang}}/{{wildcards.variant}}/summary.txt
        """

rule ngram_pipeline:
    input:
        expand("results/ngram/{lang}/{variant}/summary.txt", lang=LANGS, variant=VARIANTS)