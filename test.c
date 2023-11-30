#include <stdio.h>
#include <stdlib.h>
#define k_const 0.1f
#define n 4
void fill(float* data) {
    data[0] =28.4;   data[1] =23.9;   data[2] =27.8;   data[3] =28.0;   
    data[4] =29.1;   data[5] =22.0;   data[6] =23.4;   data[7] =27.7;   
    data[8] =22.8;   data[9] =25.5;   data[10]=24.8;   data[11]=26.3;  
    data[12]=23.6;   data[13]=25.1;   data[14]=29.5;   data[15]=29.2;  
}


int main(){
    float* a;
    float* c;
    
    a = (float*)malloc(n*n*sizeof(float));
    c = (float*)malloc(n*n*sizeof(float));
    fill(a);
    int rt,lt,cr,up,dn;
    for(int k = 0; k < 1 ; k++){		
		
		for(int i = 0; i < n ; i++){
		
			for(int j = 0; j < n ; j++){
				float newTemp = a[i*n+j];
				 
				rt = a[i*n+(j + 1)];	//right
				lt = a[i*n+(j - 1)];	//left
				cr = a[i*n+j];		//center
				up = a[(i - 1)*n+j];	//up
				dn = a[(i + 1)*n+j];	//down
				
				if(i==0)	up = cr;
				if(i==n-1)	dn = cr;
				if(j==0)	lt = cr;
				if(j==n-1)	rt = cr;

				newTemp += k_const * ( rt + lt + up + dn - 4 * newTemp );
				c[i*n+j] = newTemp;
			}
		}

		for(int i = 0; i < n ; i++){		
			for(int j = 0; j <n ; j++){
				a[i*n+j] = c[i*n+j];
			}
		}
	}
    for(int i = 0; i < n ; i++){
    
		for(int j = 0; j < n ; j++){
		    printf("%.1f  ",a[i*n+j]);
		}
		
        printf("\n");
    }
  //  fill(a);
}