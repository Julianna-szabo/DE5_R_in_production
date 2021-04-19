library(botor)
botor(region = 'eu-west-1')
shard_iterator <- kinesis_get_shard_iterator('crypto', '0')$ShardIterator
records <- kinesis_get_records(shard_iterator)

# this loop will stop when we get some records!
while (length(records$Records) == 0){
  records <- kinesis_get_records(shard_iterator)
  shard_iterator <- records$NextShardIterator
}
