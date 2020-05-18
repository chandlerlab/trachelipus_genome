import sys

fasta_file = sys.argv[1]
dict_file = sys.argv[2]

dict_handle = open(dict_file , "r")
my_dict = {}
for cur_line in dict_handle:
  cur_fields = cur_line.strip().split(",")
  my_dict[cur_fields[0]] = cur_fields[1]
dict_handle.close()

fasta_handle = open(fasta_file, "r")
for cur_line in fasta_handle:
  if (cur_line[0] == ">"):
    cur_seq = cur_line[1:].strip().split(" ")[0]
    if (("NODE" in cur_seq) or ("contig" in cur_seq)):
      new_seq = "Trachelipus_insertion"
    else:
      new_seq = my_dict[cur_seq]
    print ">" + new_seq
  else:
    print cur_line.strip()
fasta_handle.close()

