#include <stdio.h>
#include <stdlib.h>
#define k_const 0.1f

void fill(float* data) {
    data[0]=23;   data[1]=10;   data[2]=34;   data[3]=52;   data[4]=9;
    data[5]=17;   data[6]=13;   data[7]=96;   data[8]=32;   data[9]=71;
    data[10]=3;   data[11]=65;  data[12]=99;  data[13]=74;  data[14]=33;
}


int main(){
    float* a;
    float* c;
    a = (float*)malloc(3*5*sizeof(float));
    c = (float*)malloc(3*5*sizeof(float));
    fill(a);
    //float a[3][5 ] ={ { 23, 10, 34, 52, 9 } , { 17, 13, 96, 32, 71 }, { 3, 65, 99, 74, 33 } };
	//float c[3][5];
    int rt,lt,cr,up,dn;
    for(int k = 0; k < 2 ; k++){		
		
		for(int i = 0; i < 3 ; i++){
		
			for(int j = 0; j < 5 ; j++){
				float newTemp = a[i*5+j];
				 
				rt = a[i*5+(j + 1)];	//right
				lt = a[i*5+(j - 1)];	//left
				cr = a[i*4+j];		//center
				up = a[(i - 1)*5+j];	//up
				dn = a[(i + 1)*5+j];	//down
				
				if(i==0)	up = cr;
				if(i==2)	dn = cr;
				if(j==0)	lt = cr;
				if(j==4)	rt = cr;

				newTemp += k_const * ( rt + lt + up + dn - 4 * a[i*5+j] );
				c[i*5+j] = newTemp;
			}
		}

	//	for(int i = 0; i < 3 ; i++){		
	//		for(int j = 0; j <5 ; j++){
	//			a[i*5+j] = c[i][j];
	//		}
	//	}
	}
    for(int i = 0; i < 3 ; i++){
    
		for(int j = 0; j < 5 ; j++){
		    printf("%.1f  ",c[i*5+j]);
		}
		
        printf("\n");
    }
  //  fill(a);
}
