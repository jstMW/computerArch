import java.util.Scanner;
public class q5 {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        //get the input number
        System.out.println("Enter an integer x: ");
        int x = scanner.nextInt();

        //initial the variable y and z as 0
        //they will be turned into sequence of 0s (in binary) by default when
        //add 1s to them.
        int y = 0;
        int z = 0;

        //initialize a var to use it for putting 1 in z or y
        //later we should alter this at each for iteration
        boolean putInY = true;

        for (int i=0; (x>>>i) > 0; i++) {
            int currentBit = (x>>>i) & 1;

            //here to put the 1 in the corresponding place I used
            //OR operator | with itself(either y or z based on their turn)
            // since this will make 0 to one.
            if (currentBit == 1) {
                //(1<<i) we shift 1 for i times, so the 1 will be
                //at the correct index to place into the y or z
                if (putInY) {
                    y |= (1<<i);
                    //putInY = false;
                } else {
                    z |= (1<<i);
                    //putInY = true;
                }
                //the commented code also works to toggle the putInY
                //also, I could alternatively use Exclusive OR as well :)
                putInY ^= true;
            }

        }


        System.out.println("y: " + y);
        System.out.println("z: " + z);

    }
}
