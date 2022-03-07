import de.bezier.guido.*;
private static int NUM_ROWS = 20;
private static int NUM_COLS = 20;
private MSButton[][] buttons = new MSButton[NUM_ROWS][NUM_COLS]; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList<MSButton>(); //ArrayList of just the minesweeper buttons that are mined
private int gameState = 0;

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    for ( int i = 0 ; i < buttons.length ; i++ )
      for( int j = 0 ; j < buttons[i].length ; j++ )
        buttons[i][j] = new MSButton( i, j);
    setMines(50);
}
public void setMines(int mineCount)
{
    int row, col;
    for(int i = 0 ; i < mineCount ; i++){
      row = (int)(Math.random()*20);
      col = (int)(Math.random()*20);
      if(!mines.contains(buttons[row][col]))
        mines.add(buttons[row][col]);
    }
}

public void draw ()
{
    background( 0 );
    if(gameState == 1) displayWinningMessage();
    if(gameState == 2) displayLosingMessage();
}

public void displayLosingMessage()
{
  //reveal all tiles
    for ( MSButton[] i : buttons){
      for( MSButton j : i){
        j.clicked = true;
      }
    }
   stroke(255);
}
public void displayWinningMessage()
{
    stroke(255);
}
public boolean isValid(int r, int c)
{
    if(r >= 0 && c >= 0 && r <= NUM_ROWS-1 && c <= NUM_COLS-1) return true;
    return false;
}
public int countMines(int row, int col)
{
    int numMines = 0;
    if(isValid(row, col+1) && mines.contains(buttons[row][col+1])) numMines++;
    if(isValid(row+1, col+1) && mines.contains(buttons[row+1][col+1])) numMines++;
    if(isValid(row+1, col) && mines.contains(buttons[row+1][col])) numMines++;
    if(isValid(row-1, col) && mines.contains(buttons[row-1][col])) numMines++;
    if(isValid(row-1, col+1) && mines.contains(buttons[row-1][col+1])) numMines++;
    if(isValid(row-1, col-1) && mines.contains(buttons[row-1][col-1])) numMines++;
    if(isValid(row+1, col-1) && mines.contains(buttons[row+1][col-1])) numMines++;
    if(isValid(row, col-1) && mines.contains(buttons[row][col-1])) numMines++;

    return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed () 
    {
        if(gameState == 0){
          if(mouseButton == LEFT && !flagged)
            reveal(this);
          else if(mouseButton == RIGHT && clicked == false)
            flagged = !flagged;
        }
    }
     public void reveal(MSButton button){
      if ( button.clicked || !isValid(button.myRow, button.myCol)){
        
        return;
      } else if(mines.contains(button)){
        button.clicked = true;
        gameState = 2;
        displayLosingMessage();
      } else if(countMines(button.myRow, button.myCol) > 0){
        button.clicked = true;
        return;
      }
        button.clicked = true;
        if(isValid(button.myRow+1, button.myCol)) reveal(buttons[button.myRow+1][button.myCol]);
        if(isValid(button.myRow-1, button.myCol)) reveal(buttons[button.myRow-1][button.myCol]);
        if(isValid(button.myRow+1, button.myCol+1)) reveal(buttons[button.myRow+1][button.myCol+1]);
        if(isValid(button.myRow-1, button.myCol+1)) reveal(buttons[button.myRow-1][button.myCol+1]);
        if(isValid(button.myRow+1, button.myCol-1)) reveal(buttons[button.myRow+1][button.myCol-1]);
        if(isValid(button.myRow-1, button.myCol-1)) reveal(buttons[button.myRow-1][button.myCol-1]);
        if(isValid(button.myRow, button.myCol+1)) reveal(buttons[button.myRow][button.myCol+1]);
        if(isValid(button.myRow, button.myCol-1)) reveal(buttons[button.myRow][button.myCol-1]);
      
    }
    public void draw () 
    {    
        if (flagged)
            fill(0);
        else if( clicked && mines.contains(this) ) 
             fill(255,0,0);
        else if(clicked){
            fill( 200 );
            setLabel(countMines(myRow, myCol));}
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
    }
    public void showMessage(String s){
      text(s, 400, 400);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
}
