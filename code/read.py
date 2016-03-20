import numpy as np
import scipy.optimize as opt

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
    #print(RP1.shape)


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
              
        avg_RP2 = np.mean(RP2, axis = 0)
        std_RP2 = np.std(RP2, axis = 0)
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
        
              
        avg_RP3 = np.mean(RP3, axis = 0)
        std_RP3 = np.std(RP3, axis = 0)
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
        
              
        avg_RP4 = np.mean(RP4, axis = 0)
        std_RP4 = np.std(RP4, axis = 0)
        np.savetxt("W4.csv", W4, delimiter=",")
        return - (avg_RP4 / std_RP4)

    a2 = np.array([2, 3, 4, 5, 6, 7, 7, 8, 8, 9, 9, 10, 11, 12])
    a3 = np.array([ 7279.95544321,  -920.15267051,  8266.02449632, -1054.94715582, -3849.09423177, -3940.24710748])
    
    solution_c = opt.minimize(sharpe_ratio_4, a2, method = 'BFGS')

    print (solution_c)


    #print(sharpe_ratio_4(a2))











    
        
read_data("./in_sample_data.txt")
