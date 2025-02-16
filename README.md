
# WGS
This repository contains a comprehensive pipeline for analyzing bacterial genomes using multiple bioinformatics tools. The workflow automates genome annotation (Prokka), resistance gene identification (Abricate, MLST), cluster analysis (AntiSMASH, Phigaro, CCTyper), functional annotation (EggNOG-mapper, dbCAN), bacterial defense detection (DefenseFinder), and genome comparison (FastANI).

## 🚀 Usage

1. Install all the listed tools in seperate conda environments

2. Create following folder in your working directory:

```bash
 cd path_to_your_working_directory
 mkdir input
 mkdir output
 mkdir db    # Use this folder to place the dbcan databases
```

3. Clone this repository:

```bash
  git clone https://github.com/Tasnimul-Arabi-Anik/WGS.git

```
4. Edit the script: 

Change the name of conda environment(s) based on how you have named the environments during installation.
Update the source command to match the path to your conda installation.

4. Run the analysis pipeline:

```bash
 bash WGS/wgs.sh
```



## 🧬 Features

- Automates the processing of multiple bacterial genomes.
- Organizes outputs from various bioinformatics tools into a structured directory.
- Ensures reproducibility and efficiency in bacterial genomics research.

## 📁 Output Structure

```
output/
├── abricate/
├── antismash/
├── cctyper/
├── dbcan/
├── defense_predictor/
├── eggnog_mapper/
├── fastani/
├── gffs/
├── phigaro/
```

## 🛠 Tools Used

1. **Prokka** (https://github.com/tseemann/prokka)  
   - Genome annotation tool for identifying genes, coding sequences (CDS), rRNA, tRNA, and other features in bacterial genomes.  
   - **Output folder:** `output/gffs`

2. **Abricate** (https://github.com/tseemann/abricate)  
   - Mass screening of contigs for antimicrobial resistance genes and virulence factors.  
   - **Output folder:** `output/abricate`

3. **AntiSMASH** (https://github.com/antismash/antismash)  
   - Identification of secondary metabolite biosynthetic gene clusters in bacterial genomes.  
   - **Output folder:** `output/antismash`

4. **CCTyper** (https://github.com/egonozer/cctyper)  
   - Detection and classification of type I-IV CRISPR-Cas systems in bacterial genomes.  
   - **Output folder:** `output/cctyper`

5. **dbCAN** (https://github.com/linnabrown/dbCAN)  
   - Annotation of carbohydrate-active enzymes (CAZymes) in bacterial genomes.  
   - **Output folder:** `output/dbcan`

6. **DefenseFinder** (https://github.com/mdmparis/DefenseFinder)  
   - Detects bacterial defense systems such as CRISPR-Cas and restriction-modification (RM) systems.  
   - **Output folder:** `output/defense_predictor`

7. **EggNOG-mapper** (https://github.com/eggnogdb/eggnog-mapper)  
   - Functional annotation of genes based on orthology assignments.  
   - **Output folder:** `output/eggnog_mapper`

8. **FastANI** (https://github.com/ParBLiSS/FastANI)  
   - Fast and scalable computation of whole-genome Average Nucleotide Identity (ANI).  
   - **Output folder:** `output/fastani`

9. **Phigaro** (https://github.com/bobeobibo/phigaro)  
   - Phage genome identification and annotation in bacterial genomes.  
   - **Output folder:** `output/phigaro`

10. **Mlst** (https://github.com/tseemann/mlst)  
   - Multilocus Sequence Typing (MLST) for bacterial isolates, used for genotyping and evolutionary analysis.  
   - **Output folder:** `output/abricate`


## 🏁 System Requirements

- Linux OS (Ubuntu recommended)
- Conda environment with required dependencies
- Minimum 16GB RAM 

## 🤝 Contributing

Pull requests are welcome! If you'd like to add additional tools or improve the pipeline, feel free to open an issue or submit a PR.



✨ **Happy Genomics!** 🚀

