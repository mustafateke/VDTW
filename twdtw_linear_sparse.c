/**
 * Copyright (C) 2013 Quan Wang <wangq10@rpi.edu>,
 * Signal Analysis and Machine Perception Laboratory,
 * Department of Electrical, Computer, and Systems Engineering,
 * Rensselaer Polytechnic Institute, Troy, NY 12180, USA
 */

/**
 * This is the C/MEX code of dynamic time warping of two signals
 *
 * compile:
 *     mex dtw_c.c
 *
 * usage:
 *     d=dtw_c(s,t)  or  d=dtw_c(s,t,w)
 *     where s is signal 1, t is signal 2, w is window parameter
 */

#include "mex.h"
#include <stdlib.h>
#include <stdio.h>
#include <math.h>

double vectorDistance(double *s, double *t, int ns, int nt, int k, int i, int j, double *d1, double *d2)
{
    double result=0;
    double ss,tt;
    int x;
    
    ss=s[i];
    tt=t[j];
    result = fabs(ss-tt) + abs((double)d1[i] - (double)d2[j])/100.0;
    
//      printf("%f = s[i]:%f t[j]:%f d1[i]:%f d2[j]:%f i:%d j:%d\n", result, s[i], t[j], d1[i], d2[j], i, j);
    
    return result;
}

double dtw_c(double *s, double *t, int w, int ns, int nt, int k, double *d1, double *d2)
{
    double d=0;
    int sizediff=ns-nt>0 ? ns-nt : nt-ns;
    double ** D;
    int i,j;
    int j1,j2;
    double cost,temp;
    
//     printf("ns=%d, nt=%d, w=%d, s[0]=%f, t[0]=%f, d1[0]=%f, d2[0]=%f\n",ns,nt,w,s[0],t[0], d1[0], d2[0]);
    
    
    if(w!=-1 && w<sizediff) w=sizediff; // adapt window size
    
    // create D
    D=(double **)malloc((ns+1)*sizeof(double *));
    for(i=0;i<ns+1;i++)
    {
        D[i]=(double *)malloc((nt+1)*sizeof(double));
    }
    
    // initialization
    for(i=0;i<ns+1;i++)
    {
        for(j=0;j<nt+1;j++)
        {
            D[i][j]=-1;
        }
    }
    D[0][0]=0;
    
    // dynamic programming
    for(i=1;i<=ns;i++)
    {
        if(w==-1)
        {
            j1=1;
            j2=nt;
        }
        else
        {
            j1= i-w>1 ? i-w : 1;
            j2= i+w<nt ? i+w : nt;
        }
        for(j=j1;j<=j2;j++)
        {
            cost=vectorDistance(s,t,ns,nt,k,i-1,j-1, d1, d2);
            
            temp=D[i-1][j];
            if(D[i][j-1]!=-1)
            {
                if(temp==-1 || D[i][j-1]<temp) temp=D[i][j-1];
            }
            if(D[i-1][j-1]!=-1)
            {
                if(temp==-1 || D[i-1][j-1]<temp) temp=D[i-1][j-1];
            }
            
            D[i][j]=cost+temp;
        }
    }
    
    
    d=D[ns][nt];
    
    /* view matrix D */
    /*
     * for(i=0;i<ns+1;i++)
     * {
     * for(j=0;j<nt+1;j++)
     * {
     * printf("%f  ",D[i][j]);
     * }
     * printf("\n");
     * }
     */
    
    // free D
    for(i=0;i<ns+1;i++)
    {
        free(D[i]);
    }
    free(D);
    
    return d;
}

/* the gateway function */
void mexFunction( int nlhs, mxArray *plhs[],
        int nrhs, const mxArray *prhs[])
{
    double *s,*t;
    int w;
    int ns,nt,k;
    double *dp;
    double *d1;
    double *d2;
    
    /*  check for proper number of arguments */
    if(nrhs!=4&&nrhs!=5)
    {
        mexErrMsgIdAndTxt( "MATLAB:dtw_c:invalidNumInputs",
                "Four or Five inputs required.");
    }
    if(nlhs>1)
    {
        mexErrMsgIdAndTxt( "MATLAB:dtw_c:invalidNumOutputs",
                "dtw_c: One output required.");
    }
    
    /* check to make sure w is a scalar */
    if(nrhs==4)
    {
        w=-1;
    }
    else if(nrhs==5)
    {
        if( !mxIsDouble(prhs[4]) || mxIsComplex(prhs[4]) ||
                mxGetN(prhs[4])*mxGetM(prhs[2])!=1 )
        {
            mexErrMsgIdAndTxt( "MATLAB:dtw_c:wNotScalar",
                    "dtw_c: Input w must be a scalar.");
        }
        
        /*  get the scalar input w */
        w = (int) mxGetScalar(prhs[4]);
    }
    
    
    /*  create a pointer to the input matrix s */
    s = mxGetPr(prhs[0]);
    
    /*  create a pointer to the input matrix t */
    t = mxGetPr(prhs[1]);
    
    d1 = mxGetPr(prhs[2]);
    d2 = mxGetPr(prhs[3]);
    
    /*  get the dimensions of the matrix input s */
    ns = mxGetM(prhs[0]);
    k = mxGetN(prhs[0]);
    
    /*  get the dimensions of the matrix input t */
    nt = mxGetM(prhs[1]);
    if(mxGetN(prhs[1])!=k)
    {
        mexErrMsgIdAndTxt( "MATLAB:dtw_c:dimNotMatch",
                "dtw_c: Dimensions of input s and t must match.");
    }
    
    
    /*  set the output pointer to the output matrix */
    plhs[0] = mxCreateDoubleMatrix( 1, 1, mxREAL);
    
    /*  create a C pointer to a copy of the output matrix */
    dp = mxGetPr(plhs[0]);
    
    /*  call the C subroutine */
//     printf("call the C subroutine");
    dp[0]=dtw_c(s,t,w,ns,nt,k, d1, d2);
    
    
    return;
    
}
