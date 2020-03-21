#include <iostream>
#include <stdio.h>
#include <math.h>

using namespace std;

struct cache_content
{
	unsigned int age;
	unsigned int tag;
    // unsigned int	data[16];
};

const int K = 1024;

double log2(double n)
{  
    // log(n) / log(2) is log2.
    return log(n) / log(double(2));
}


void simulate(int cache_size, int block_size, int ways)
{
	unsigned int tag, index, x;

	int offset_bit = (int)log2(block_size);
	int index_bit = (int)log2(cache_size / ways / block_size);
	int line = cache_size >> (offset_bit);
	int total=0;
    int miss=0;
	int cur_age=0;
		
	cache_content *cache = new cache_content[line];
	
	std::cout << "ways:" << ways << "    ";
	std::cout << "cache_size:" << cache_size << "    ";
    std::cout << "block_size:" << block_size << std::endl;
    std::cout << "cache line:" << line << "    ";
    std::cout << "offset_bit:" << offset_bit << "    ";
    std::cout << "index_bit:"  << index_bit << std::endl;
	/*
	//total bit = (2^index bits) * (valid bits + tag bits + (data bits * 2^offset bits))
	int total_bit;
	total_bit=pow(2,index_bit)*(1+(32-2-index_bit-offset_bit)+32*pow(2,offset_bit));	//Because of setting, 2^offset_bit = block_size = 64
	*/
	
	for(int i = 0; i < line; i++){
		cache[i].tag=0;
		cache[i].age=0;
	} 
	
    //FILE *fp = fopen("LU.txt", "r");  // read file
	FILE *fp = fopen("RADIX.txt", "r");  // read file
	
	while(fscanf(fp, "%x", &x) != EOF)
    {
		total++ ;
		cur_age++;
		//cout << hex << x << " ";
		index = ((x >> offset_bit) & ((line/ways) - 1))*ways;
		tag = x >> (index_bit + offset_bit);
		bool hit=0;
		for(int i=0;i<ways;i++)
		{
			if(cache[index+i].age > 0 && cache[index+i].tag == tag)	// hit
			{
			 	cache[index+i].age=cur_age;
			 	hit=1;
			 	break;
			}
		}                 
		if(hit==0)	// miss
        {
        	miss++;
			int min;
			int index_i=0;
			bool fir=1;
			for(int i=0;i<ways;i++)
			{
				if(cache[index+i].age==0)	//pick an empty one
				{
					index_i=i;
					break;
				}
				else	//else, find the youngest
				{
					if(fir)
					{
						min=cache[index+i].age;
						index_i=i;
						fir=0;
					}
					if(cache[index+i].age<min)
					{
						min=cache[index+i].age;
                    	index_i=i;
					}
				}
			}
			cache[index+index_i].age=cur_age;
            cache[index+index_i].tag=tag;
		}
	}
	fclose(fp);

	delete [] cache;
  std::cout << "miss rate:" << (miss / (double)total) << std::endl;
  //std::cout << "total bit:"<<total_bit<< std::endl;
  std::cout << "---------------------" << std::endl;
}

int main(void)
{
	// Let us simulate XKB cache with YKB blocks
	simulate( 1*K, 64, 1);
	simulate( 1*K, 64, 2);
	simulate( 1*K, 64, 4);
	simulate( 1*K, 64, 8);
    simulate( 2*K, 64, 1);
	simulate( 2*K, 64, 2);
	simulate( 2*K, 64, 4);
	simulate( 2*K, 64, 8);
	simulate( 4*K, 64, 1);
	simulate( 4*K, 64, 2);
	simulate( 4*K, 64, 4);
	simulate( 4*K, 64, 8);
	simulate( 8*K, 64, 1);
	simulate( 8*K, 64, 2);
	simulate( 8*K, 64, 4);
	simulate( 8*K, 64, 8);
	simulate( 16*K, 64, 1);
	simulate( 16*K, 64, 2);
	simulate( 16*K, 64, 4);
	simulate( 16*K, 64, 8);
    simulate( 32*K, 64, 1);
	simulate( 32*K, 64, 2);
	simulate( 32*K, 64, 4);
	simulate( 32*K, 64, 8);
	
	return 0;
	
}
