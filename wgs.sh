#!/bin/bash
set -euo pipefail

# Initialize Conda for the current shell session (if necessary)
#source ~/miniconda3/etc/profile.d/conda.sh 
source ~/miniforge3/etc/profile.d/conda.sh

# Running Abricate
SECONDS=0

conda activate /home/anik/miniconda3/envs/wgs
# Create the base output directory if it doesn't exist
mkdir -p output/abricate
find input/*/ -type f \( -name "*.fna" -o -name "*.fasta" \) | parallel --jobs $(nproc --ignore=1) "
  base_name=\$(basename {} .fna);  # Removes .fna if present
  base_name=\${base_name%.fasta};  # Removes .fasta if present

  # Check if abricate output already exists
  if [ ! -f output/abricate/\$base_name/ncbi.csv ]; then
    echo \"Running abricate on \$base_name\"
    mkdir -p output/abricate/\$base_name
    mlst --csv {} > output/abricate/\$base_name/mlst.csv
    abricate --csv {} --db vfdb > output/abricate/\$base_name/vfdb.csv
    abricate --csv {} --db resfinder > output/abricate/\$base_name/resfinder.csv
    abricate --csv {} --db megares > output/abricate/\$base_name/megares.csv
    abricate --csv {} --db plasmidfinder > output/abricate/\$base_name/plasmidfinder.csv
    abricate --csv {} --db card > output/abricate/\$base_name/card.csv
    abricate --csv {} --db argannot > output/abricate/\$base_name/argannot.csv
    abricate --csv {} --db ncbi > output/abricate/\$base_name/ncbi.csv
    abricate --csv {} --db ecoh > output/abricate/\$base_name/ecoh.csv
  else
    echo \"Skipping abricate on \$base_name (already completed)\"
  fi
"

# Check if the merged file already exists
if [ ! -f output/abricate/combined_results.csv ]; then
  echo "Merging CSV files..."

  awk 'NR == 1 {print; next} FNR > 1' output/abricate/*/*vfdb.csv > output/abricate/vfdb.csv
  awk 'NR == 1 {print; next} FNR > 1' output/abricate/*/*resfinder.csv > output/abricate/resfinder.csv
  awk 'NR == 1 {print; next} FNR > 1' output/abricate/*/*plasmidfinder.csv > output/abricate/plasmidfinder.csv
  awk 'NR == 1 {print; next} FNR > 1' output/abricate/*/*card.csv > output/abricate/card.csv
  awk 'NR == 1 {print; next} FNR > 1' output/abricate/*/*ncbi.csv > output/abricate/ncbi.csv
  awk 'NR == 1 {print; next} FNR > 1' output/abricate/*/*argannot.csv > output/abricate/argannot.csv
  awk 'NR == 1 {print; next} FNR > 1' output/abricate/*/*megares.csv > output/abricate/megares.csv
  awk 'NR == 1 {print; next} FNR > 1' output/abricate/*/*ecoh.csv > output/abricate/ecoh.csv
  awk 'NR == 1 {print; next} FNR > 1' output/abricate/*/*mlst.csv > output/abricate/mlst.csv

  # Combine all CSV files into one
  awk 'NR == 1 {print; next} FNR > 1' output/abricate/*.csv > output/abricate/combined_results.csv

  echo "CSV merging completed!"
else
  echo "Merging skipped (already completed)."
fi

conda deactivate 




# Annotation using Prokka
conda activate /home/anik/miniconda3/envs/pangenome
find input/*/ -type f \( -name "*.fna" -o -name "*.fasta" \) | parallel --jobs $(nproc --ignore=1) "
  base_name=\$(basename {} .fna);
  base_name=\${base_name%.fasta};
  
  # Check if Prokka output already exists
  if [ ! -f output/gffs/\$base_name/\$base_name.gff ]; then
    echo \"Running Prokka on \$base_name\"
    mkdir -p output/gffs/\$base_name
    prokka --cpus 24 --prefix \"\$base_name\" --force --outdir output/gffs/\$base_name {}
  else
    echo \"Skipping Prokka for \$base_name (already completed)\"
  fi
"
conda deactivate




#If you find error ERROR: Did not recognise the LOCUS line layout:
#LOCUS       NODE_1_length_480839_cov_19.828950480839 bp   DNA linear
#python scripts/parallel/fix_locus.py  output/gffs/*/

# Running AntiSMASH
conda activate /home/anik/miniconda3/envs/antismash
find output/gffs/*/ -type f -name "*.gbk" | parallel --verbose --jobs 4 "
  base_name=\$(basename {} .gbk);
  # Check if AntiSMASH output already exists
  if [ ! -d output/antismash/\$base_name ]; then
    echo \"Running AntiSMASH on \$base_name\"
    mkdir -p output/antismash/\$base_name
    antismash --genefinding-tool none -c 16 --cb-subclusters --cb-knownclusters --smcog-trees --output-dir output/antismash/\$base_name {}
  else
    echo \"Skipping AntiSMASH for \$base_name (already completed)\"
  fi
"
conda deactivate


#Running cctyper
	#activating the environment
conda activate cctyper
	# Create the base output directory if it doesn't exist
mkdir -p output/cctyper
	# Run cctyper in parallel
find input/*/ -type f \( -name "*.fna" -o -name "*.fasta" \) | parallel --jobs $(nproc --ignore=1) "
  base_name=\$(basename {} .fna);  # Removes .fna if present
  base_name=\${base_name%.fasta};  # Removes .fasta if present
   if [ ! -d output/cctyper/\$base_name ]; then
    echo \"Running cctyper on \$base_name\"
    cctyper {} output/cctyper/\$base_name
  else
    echo \"Skipping cctyper for \$base_name (already completed)\"
  fi
"
	# Deactivate the conda environment
conda deactivate



#Running dbcan
	#activating the environment
conda activate dbcan
	# Create the base output directory if it doesn't exist
mkdir -p output/dbcan
	# Run dbcan in parallel
find input/*/ -type f \( -name "*.fna" -o -name "*.fasta" \) | parallel --jobs 6 "
  base_name=\$(basename {} .fna);  # Removes .fna if present
  base_name=\${base_name%.fasta};  # Removes .fasta if present
  if [ ! -d output/dbcan/\$base_name ]; then
    echo \"Running dbcan on \$base_name\"
    run_dbcan {} prok --db_dir db/ --out_dir output/dbcan/\$base_name;
    run_dbcan {} prok -c cluster --out_dir output/dbcan/\$base_name
  else
    echo \"Skipping dbcan for \$base_name (already completed)\"
  fi
"
	# Deactivate the conda environment
conda deactivate



#Running phigaro
	#activating the environment
conda activate cctyper
	# Create the base output directory if it doesn't exist
mkdir -p output/phigaro
	#Run pgigaro in parallel
find input/*/ -type f \( -name "*.fna" -o -name "*.fasta" \) | parallel --jobs $(nproc --ignore=1) "
  base_name=\$(basename {} .fna);  # Removes .fna if present
  base_name=\${base_name%.fasta};  # Removes .fasta if present
  if [ ! -d output/phigaro/\$base_name ]; then
    echo \"Running phigaro on \$base_name\"
    mkdir -p output/phigaro/\$base_name;
    echo y | phigaro -t 24 -f {} -o output/phigaro/\$base_name --not-open -e tsv html
  else
    echo \"Skipping phigaro for \$base_name (already completed)\"
  fi
"
	# Deactivate the conda environment
conda deactivate



#Running Defense_Predictor
conda activate defense-predictor
	# Create the base output directory if it doesn't exist
mkdir -p output/defense_predictor
	# Run defense_predictor in parallel
find output/gffs/ -type f -name "*.gff" | parallel --verbose --jobs 2 "
  base_name=\$(basename {} .gff);
  mkdir -p output/defense_predictor/\$base_name;
  if [ ! -d output/defense_predictor/\$base_name ]; then
    echo \"Running defense_predictor on \$base_name\"
    defense_predictor \
      --prokka_gff {} \
      --prokka_ffn output/gffs/\$base_name/\$base_name.ffn \
      --prokka_faa output/gffs/\$base_name/\$base_name.faa \
      --output output/defense_predictor/\$base_name/\$base_name.csv
  else
    echo \"Skipping defense_predictor for \$base_name (already completed)\"
  fi
"
	# Deactivate the conda environment
conda deactivate



# Activate the eggnog_mapper conda environment
conda activate eggnog_mapper

# Create the base output directory if it doesn't exist
mkdir -p output/eggnog_mapper

# Run eggnog_mapper in parallel
find output/gffs/ -type f -name "*.faa" | parallel --verbose --jobs 1 "
  base_name=\$(basename {} .faa);
  
  # Check if annotation already exists
  if [ ! -f output/eggnog_mapper/\$base_name/\$base_name.emapper.annotations ]; then
    echo \"Running eggnog_mapper on \$base_name\"
    mkdir -p output/eggnog_mapper/\$base_name
    emapper.py -i {} --output_dir output/eggnog_mapper/\$base_name --cpu 24 --tax_scope bacteria --output \$base_name
  else
    echo \"Skipping eggnog_mapper for \$base_name (already completed)\"
  fi
"

# Deactivate the conda environment
conda deactivate



# Ask user if they have genomes from the same bacterial species
read -p "Are the genomes belong to the same bacterial species? (y/n): " answer

# Convert to lowercase and check the response
if [[ "$answer" != "y" && "$answer" != "Y" ]]; then
    echo "Process terminated."
    exit 1
fi

# Activating fastani
conda activate fastani

if [ ! -d output/fastani ]; then
  echo "Running fastani"

  # Create the base output directory if it doesn't exist
  mkdir -p output/fastani
  # Create a directory for the input genomes
  mkdir -p input/genomes
  # Copy all .fna files into the directory (ensures it works even if no files exist)
  find input/* -type f -name "*.fna" -exec cp {} input/genomes/ \;
  # Run ANIclustermap
  ANIclustermap -i input/genomes -o output/fastani
  # Remove the genomes directory and its contents
  rm -rf input/genomes
else
  echo "Skipping fastani (already completed)"
fi

# Deactivate Conda environment
conda deactivate


duration=$SECONDS
echo "$(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."

