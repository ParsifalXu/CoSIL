export PYTHONPATH=$PYTHONPATH:$(pwd)
export PROJECT_FILE_LOC="repo_structures"
export HF_ENDPOINT=https://hf-mirror.com

# Fault Localization
models=("gpt-4o")
model_names=("gpt-4o-2024-05-13")
backend=("openai")
threads=200

for i in "${!models[@]}"; do
  python afl/fl/AFL_localize_file.py --file_level \
                               --output_folder "results/pattern-bench/file_level_${models[$i]}" \
                               --num_threads ${threads} \
                               --model "${model_names[$i]}" \
                               --backend "${backend[$i]}" \
                               --skip_existing
done

for i in "${!models[@]}"; do
  python afl/fl/AFL_localize_func.py \
    --output_folder "results/pattern-bench/func_level_${models[$i]}" \
    --loc_file "results/pattern-bench/file_level_${models[$i]}/loc_outputs.jsonl" \
    --output_file "loc_${models[$i]}_func.jsonl" \
    --temperature 0.85 \
    --model "${model_names[$i]}" \
    --backend "${backend[$i]}" \
    --skip_existing \
    --num_threads ${threads}
done




