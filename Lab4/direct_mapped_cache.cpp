#include <iostream>
#include <stdio.h>
#include <math.h>

using namespace std;

struct cache_content
{
	bool v;
	unsigned int tag;
    // unsigned int	data[16];
};

const int K = 1024;

double log2(double n)
{  
    // log(n) / log(2) is log2.
    return log(n) / log(double(2));
}


void simulate(int cache_size, int block_size)
{
	unsigned int tag, index, x;

	int offset_bit = (int)log2(block_size);
	int index_bit = (int)log2(cache_size / block_size);
	int line = cache_size >> (offset_bit);
	int total=0;
    int miss=0;
	
	cache_content *cache = new cache_content[line];
	
	std::cout << "cache_size:" << cache_size << "    ";
    std::cout << "block_size:" << block_size << std::endl;
    std::cout << "cache line:" << line << "    ";
    std::cout << "offset_bit:" << offset_bit << "    ";
    std::cout << "index_bit:"  << index_bit << std::endl;

	for(int j = 0; j < line; j++)
		cache[j].v = false;
	
    //FILE *fp = fopen("DCACHE.txt", "r");  // read file
	FILE *fp = fopen("ICACHE.txt", "r");  // read file
	
	while(fscanf(fp, "%x", &x) != EOF)
    {
		total++ ;
		//cout << hex << x << " ";
		index = (x >> offset_bit) & (line - 1);
		tag = x >> (index_bit + offset_bit);
		if(cache[index].v && cache[index].tag == tag)
			cache[index].v = true;                     // hit
		else
        {
			cache[index].v = true;                     // miss
			cache[index].tag = tag;
			miss++;
		}
	}
	fclose(fp);

	delete [] cache;
  std::cout << "miss rate:" << (miss / (double)total) << std::endl;
  std::cout << "---------------------" << std::endl;
}

int main(void)
{
	// Let us simulate XKB cache with YKB blocks
	simulate( 32, 1);
	simulate( 32, 2);
	simulate( 32, 4);
	simulate( 32, 8);
	simulate( 32, 16);
    simulate( 64, 1);
	simulate( 64, 2);
	simulate( 64, 4);
	simulate( 64, 8);
	simulate( 64, 16);
	simulate( 128, 1);
	simulate( 128, 2);
	simulate( 128, 4);
	simulate( 128, 8);
	simulate( 128, 16);
	simulate( 256, 1);
	simulate( 256, 2);
	simulate( 256, 4);
	simulate( 256, 8);
	simulate( 256, 16);
	
	return 0;
}
