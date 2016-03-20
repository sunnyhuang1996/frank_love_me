import numpy as np
import scipy.optimize as opt
import scipy.stats as stat
import matplotlib.pyplot as plt
def read_data(filename):
    # read in data
    data = np.loadtxt(filename, delimiter=',')
    #print(data.shape)
    date = data[:,0]
    data = data[:, 1:]

    data = data.reshape(1003, 100,6)

    #SC = data[:, :, 3]
    SC_prev = data[:-1, :, 3]
    SC = data[1:, : , 3]
    RCC = SC / SC_prev -1 

    # calculate avg RCC
    avg_RCC = np.mean(RCC, axis=1)
    #print(avg_RCC[0])
    

    # calculate W1

    W1 = -(1/100) * (RCC.transpose()-avg_RCC).transpose()
    #print(W1.shape)
    #np.savetxt("W1.csv", W1, delimiter=",")

    #RP1
    RP1 = (np.sum((W1*RCC), axis=1))/(np.sum(np.absolute(W1), axis=1))
    print ("rp1 skew---> " , stat.skew(RP1) )
    print ("rp1 kurt---> " , stat.kurtosis(RP1) )
    print ("rp1 avg log---> ", np.mean(np.log(RP1 + 1), axis = 0))
    print ("rp1 std log---> ", np.std(np.log(RP1 + 1), axis = 0))      
    print ("rp1 corr--->", np.corrcoef(avg_RCC, RP1)[0, 1])
    #print(RP1.shape)

    '''
    part1_end = np.argmax(np.maximum.accumulate(RP1) - RP1) # end of the period
    part1_start = np.argmax(RP1[:part1_end]) # start of period
    print(part1_start, part1_end)
    plt.plot(RP1)
    plt.plot([part1_end, part1_start], [RP1[part1_end], RP1[part1_start]], 'o', color='Red', markersize=10)    
    '''
    #======================== part 2 ==============================

    SO_prev = data[:-1, :, 0]
    SO = data[1:, : , 0]
    RCO = SO / SC_prev -1 
    avg_RCO = np.mean(RCO, axis=1)
    
    ROC = SC / SO - 1
    avg_ROC = np.mean(ROC, axis=1)
    
    ROO = SO / SO_prev - 1
    avg_ROO = np.mean(ROO, axis=1)
    
    SH = data[1:, :, 1] 
    SL = data[1:, :, 2]
    
    RVP = (1 / (4 * np.log(2))) * ((np.log(SH) - np.log(SL))** 2)

    #print(RVP.shape)

    TVL = data[:-1, :, 4]
    
    avg_TVL = np.zeros((1002, 100))
    for j in range(0, 100):
        for i in range(0, 1002):
            start = max(0, i-199)
            avg_TVL[i][j] = np.mean(TVL[start:i+1, j])



    avg_RVP = np.zeros((1002, 100))
    for j in range(0, 100):
        for i in range(0, 1002):
            start = max(0, i-199)
            avg_RVP[i][j] = np.mean(RVP[start:i+1, j])


    N=100

    #a = np.array([a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12]);
    def sharpe_ratio(a):
    
        W2 =   a[0]*((RCC.transpose()-avg_RCC).transpose())/N+ \
               a[1]*((ROO.transpose()-avg_ROO).transpose())/N + \
               a[2]*((ROC.transpose()-avg_ROC).transpose())/N + \
               a[3]*((RCO.transpose()-avg_RCO).transpose())/N + \
               a[4]*(TVL/avg_TVL)*((RCC.transpose()-avg_RCC).transpose())/N +\
               a[5]*(TVL/avg_TVL)*((ROO.transpose()-avg_ROO).transpose())/N + \
               a[6]*(TVL/avg_TVL)*((ROC.transpose()-avg_ROC).transpose())/N  + \
               a[7]*(TVL/avg_TVL)*((RCO.transpose()-avg_RCO).transpose())/N + \
               a[8]*(RVP/avg_RVP)*((RCC.transpose()-avg_RCC).transpose())/N+ \
               a[9]*(RVP/avg_RVP)*((ROO.transpose()-avg_ROO).transpose())/N + \
               a[10]*(RVP/avg_RVP)*((ROC.transpose()-avg_ROC).transpose())/N + \
               a[11]*(RVP/avg_RVP)*((RCO.transpose()-avg_RCO).transpose())/N

        RP2 = (np.sum((W2 * ROC), axis=1)) / (np.sum(np.absolute(W2), axis=1))
        print ("rp2 skew---> ", stat.skew(RP2) )     
        print ("rp2 kurt---> ", stat.kurtosis(RP2) )   
        '''
        part2_end = np.argmax(np.maximum.accumulate(RP2) - RP2) # end of the period
        part2_start = np.argmax(RP2[:part2_end]) # start of period
        print(part2_start, part2_end)
        plt.plot(RP2)
        plt.plot([part2_end, part2_start], [RP2[part2_end], RP2[part2_start]], 'o', color='Red', markersize=10)   
        '''
        avg_RP2 = np.mean(RP2, axis = 0)
        std_RP2 = np.std(RP2, axis = 0)
        print ("rp2 avg log---> ", np.mean(np.log(RP2 + 1), axis = 0))
        print ("rp2 std log---> ", np.std(np.log(RP2 + 1), axis = 0)) 
        print ("rp2 corr--->", np.corrcoef(avg_ROC, RP2)[0, 1])
        #np.savetxt("W2.csv", W2, delimiter=",")

        return - (avg_RP2 / std_RP2)

    #a0 = np.array([1, 1, 1, -1, 1, -1, 1, -1, 1, -1, 1, -1])
    #solution = opt.minimize(sharpe_ratio, a0)

    #print (solution)

    #===================================Part 3====================================================
    IND = data[1:, :, 5]

    
    def sharpe_ratio_3(a):

        W3 =   a[0]*((RCC.transpose()-avg_RCC).transpose())/N+ \
               a[1]*((ROO.transpose()-avg_ROO).transpose())/N + \
               a[2]*((ROC.transpose()-avg_ROC).transpose())/N + \
               a[3]*((RCO.transpose()-avg_RCO).transpose())/N + \
               a[4]*(TVL/avg_TVL)*((RCC.transpose()-avg_RCC).transpose())/N +\
               a[5]*(TVL/avg_TVL)*((ROO.transpose()-avg_ROO).transpose())/N + \
               a[6]*(TVL/avg_TVL)*((ROC.transpose()-avg_ROC).transpose())/N  + \
               a[7]*(TVL/avg_TVL)*((RCO.transpose()-avg_RCO).transpose())/N + \
               a[8]*(RVP/avg_RVP)*((RCC.transpose()-avg_RCC).transpose())/N+ \
               a[9]*(RVP/avg_RVP)*((ROO.transpose()-avg_ROO).transpose())/N + \
               a[10]*(RVP/avg_RVP)*((ROC.transpose()-avg_ROC).transpose())/N + \
               a[11]*(RVP/avg_RVP)*((RCO.transpose()-avg_RCO).transpose())/N
        
        FILL3 = np.int64(W3 * IND >=0)
        
        RP3=np.zeros(1002)
        for i in range(1002):
            if (np.sum(np.absolute((W3)[i] * FILL3[i]))>0):
                RP3[i] = (np.sum(W3[i] * ROC[i] * FILL3[i])) / np.sum(np.absolute((W3)[i] * FILL3[i]))    
        print ("rp3 skew---> ", stat.skew(RP3) )   
        print ("rp3 kurt---> ", stat.kurtosis(RP3) )      
        '''
        part3_end = np.argmax(np.maximum.accumulate(RP3) - RP3) # end of the period
        part3_start = np.argmax(RP3[:part3_end]) # start of period
        print(part3_start, part3_end)
        plt.plot(RP3)
        plt.plot([part3_end, part3_start], [RP3[part3_end], RP3[part3_start]], 'o', color='Red', markersize=10)   
        '''
        avg_RP3 = np.mean(RP3, axis = 0)
        std_RP3 = np.std(RP3, axis = 0)
        print ("rp3 avg log---> ", np.mean(np.log(RP3 + 1), axis = 0))
        print ("rp3 std log---> ", np.std(np.log(RP3 + 1), axis = 0))     
        print ("rp3 corr--->", np.corrcoef(avg_ROC, RP3)[0, 1])
        #np.savetxt("W3.csv", W3, delimiter=",")
        return - (avg_RP3 / std_RP3)

    #a1 = np.array([2, 3, 4, 5, 6, 7, 8, 9, 10,11,12,13])
    #solution_b = opt.minimize(sharpe_ratio_3, a1, method = 'BFGS')

    #print (solution_b)


    #print(sharpe_ratio_3(a1))



    #=================================== part 4==================================================
    IND = data[1:, :, 5]
    RHC = (SH/SC) - 1
    RLC = (SL/SC) - 1
    avg_RHC = np.mean(RHC, axis=1)
    avg_RLC = np.mean(RLC, axis=1)

    
    def sharpe_ratio_4(a):

        W4 =   a[0]*((RCC.transpose()-avg_RCC).transpose())/N+ \
               a[1]*((ROO.transpose()-avg_ROO).transpose())/N + \
               a[2]*((ROC.transpose()-avg_ROC).transpose())/N + \
               a[3]*((RCO.transpose()-avg_RCO).transpose())/N + \
               a[4]*((RHC.transpose()-avg_RHC).transpose())/N+ \
               a[5]*((RLC.transpose()-avg_RLC).transpose())/N +\
               a[6]*(TVL/avg_TVL)*((RCC.transpose()-avg_RCC).transpose())/N +\
               a[7]*(TVL/avg_TVL)*((ROO.transpose()-avg_ROO).transpose())/N + \
               a[8]*(TVL/avg_TVL)*((ROC.transpose()-avg_ROC).transpose())/N  + \
               a[9]*(TVL/avg_TVL)*((RCO.transpose()-avg_RCO).transpose())/N + \
               a[10]*(RVP/avg_RVP)*((RCC.transpose()-avg_RCC).transpose())/N+ \
               a[11]*(RVP/avg_RVP)*((ROO.transpose()-avg_ROO).transpose())/N + \
               a[12]*(RVP/avg_RVP)*((ROC.transpose()-avg_ROC).transpose())/N + \
               a[13]*(RVP/avg_RVP)*((RCO.transpose()-avg_RCO).transpose())/N 

               
        
        FILL4 = np.int64(W4 * IND >=0)
        
        RP4=np.zeros(1002)
        for i in range(1002):
            if (np.sum(np.absolute((W4)[i] * FILL4[i]))>0):
                RP4[i] = (np.sum(W4[i] * ROC[i] * FILL4[i])) / np.sum(np.absolute((W4)[i] * FILL4[i]))    
        print ("rp4 skew---> ", stat.skew(RP4) )   
        print ("rp4 kurt---> ", stat.kurtosis(RP4) )
        '''
        part4_end = np.argmax(np.maximum.accumulate(RP4) - RP4) # end of the period
        part4_start = np.argmax(RP4[:part4_end]) # start of period
        print(part4_start, part4_end)
        plt.plot(RP4)
        plt.plot([part4_end, part4_start], [RP4[part4_end], RP4[part4_start]], 'o', color='Red', markersize=10) 
        '''
        avg_RP4 = np.mean(RP4, axis = 0)
        std_RP4 = np.std(RP4, axis = 0)
        
        print ("rp4 avg log---> ", np.mean(np.log(RP4 + 1), axis = 0))
        print ("rp4 std log---> ", np.std(np.log(RP4 + 1), axis = 0))
        print ("rp4 corr--->", np.corrcoef(avg_ROC, RP4)[0, 1])
        #np.savetxt("W4.csv", W4, delimiter=",")
        return - (avg_RP4 / std_RP4)

    #a2 = np.array([2, -3, 4, 5, -6, -7, 7, -8, 8,-9, 9, -10, 10, -11])
    #solution_c = opt.minimize(sharpe_ratio_4, a2, method = 'BFGS')

    #print (solution_c)


    #print(sharpe_ratio_4(a2))
    
    x_part2 = np.array([ -68.10983666,    1.79602723,  117.50046364,   66.64878082,
        116.89628852,   -1.59469973, -116.83854757, -112.75071979,
         -5.12491025,   -0.62930349,    2.28357394,    2.8923232 ])
    
    print ("rp2 annual SR--->", (-1) * sharpe_ratio(x_part2) * np.sqrt(252))
    
    x_part3 = np.array([ -573.07367821,   -57.28733054,  1389.21669851,   967.95444608,
        -191.01163743,   -19.4200118 ,   190.55654005,   101.89769541,
        -217.69656296,    39.30077631,   194.3012575 ,    37.95235561])
    print ("rp3 annual SR--->", (-1) * sharpe_ratio_3(x_part3) * np.sqrt(252))
    
    x_part4 = np.array([ 32.64473236,  -2.80703281,  43.3879628 ,   1.76297939,
       -48.90627241, -17.51553152,  -1.09869875,  -3.40711969,
         2.2544375 ,  -9.82175265,  -8.34455527,   6.05419687,
         3.7713043 ,  -9.03017505])
    print ("rp4 annual SR--->", (-1) * sharpe_ratio_4(x_part4) * np.sqrt(252))

       
read_data("./in_sample_data.txt")
