import sys

blast_file = open(sys.argv[1], 'r')
all_lines = blast_file.readlines()
blast_file.close()

num_letters = int(sys.argv[2])

#432 for nucleotides

all_contigs = []
for cur_line in all_lines:
  cur_contig = cur_line.strip().split("\t")[1]
  if not (cur_contig in all_contigs):
    all_contigs.append(cur_contig)
    
#query = p_scaber_agh
#subject = unknown_contig

for cur_contig in all_contigs:
  cur_agh = '-' * num_letters
  #cur_agh = '1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345'
  for cur_line in all_lines:
    cur_fields = cur_line.strip().split("\t")
    if (cur_fields[1] == cur_contig):
      qstart = int(cur_fields[6])
      qend = int(cur_fields[7])
      cur_agh = cur_agh[0:qstart-1] + cur_fields[11] + cur_agh[qend:]
  print ">" + cur_contig
  print cur_agh
  
