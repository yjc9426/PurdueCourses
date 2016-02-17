import java.util.Date;
import java.util.Scanner;
class MyThread implements Runnable
{
    int task;
    @Override
    public void run()
    {
        hw11.thcounter++;
        while( (task = hw11.getTask()) != -1 )
        {
            System.out.println(Thread.currentThread().getName()+"\tstart to calculate "+(task+1)+" row");
            for(int i=0; i<hw11.n; i++)
            {
                for(int j=0; j<hw11.n; j++)
                {
                    hw11.A[task][i] += hw11.B[task][j] * hw11.C[j][i];
                }
            }
        }
        hw11.thcounter--;
    }
}
public class hw11
{
    static int[][] B;
    static int[][] C;
    static int[][] A;
    static int n, thrnum,index;
    static int thcounter;
    static long startTime;
	private static Scanner in;
	private static Scanner i;
    
    public static void main(String[] args) throws MyException, InterruptedException{
    	System.out.println("Please enter number of thread: ");
		i = new Scanner(System.in);
		thrnum = i.nextInt();
    	
    	
    	while(true){
    		try{
    			System.out.println("Please enter dimension N: ");
    			in = new Scanner(System.in);
    			n = in.nextInt();
    			if (n % 2 != 0){
    				throw new MyException();
    			}
    			break;
    		}catch(MyException e){
    			System.out.println("N needs to be the number which can divided by 2");
    		}
    	}
        B = new int[n][n];
        C = new int[n][n];
        A = new int[n][n];
        B = fill(n);
        C = fill(n);
        startTime = new Date().getTime();

        for(int i=0; i<thrnum; i++){
            Thread t = new Thread(new MyThread());
            t.start();
        }
        
        while(thcounter!=0){
            Thread.sleep(20);
        }
        long finishTime = new Date().getTime();
        System.out.println("Finished, time is "+(finishTime-startTime)+"ms");
    }

    static int [][] fill(int n)
    {
    	int[][] x;
    	x = new int [n][n];
        for (int i=1; i<n; i++)
        {
            for(int j=0; j<n; j++)
            {
                x[i][j] = (int) (Math.random()*1);
            }
        }
        return x;
    }

    synchronized static int getTask()
    {
        if(index < n)
        {
            return index++;
        }
        return -1;
    }

}

