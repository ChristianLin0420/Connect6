# Connect6
Using my own ML technique to play connect 6, and users can train their own players and fight with others online.

## About the App
* Using unique Machine Learning technique to play connect6
* Users can train their own models according to the way they used
* iOS device is avalible now (Swift 5)
* Prototype / Keep Updating

## Usage
  All you need to do is to download all files above, and run it on Xcode, 
  and start to train your first virtual student and defeat others online.

## Machine Learning Explanation

### How to create patterns?
![image](https://i.imgur.com/jb5kbXd.png)

  1. Everytime the user put a chess on the board, the program will automatically create a 11x11 square with the chess on the center.
  2. The program will break down the the pattern into 4 different angle straight lines(0, 45, 90, 135 degree respectively).
  3. The program will create all combinations according to the 4 lines from (2).
  4. Encoding the patterns into binary and compress the binary data.

### How to update database and score?
![image](https://i.imgur.com/SvpPDSW.png)

  1. According to the encoded data above, the program will check whether the database has same pattern.
  2. If current checking pattern exists, then we plus the score and refresh the database, otherwise, we append this pattern into the database and initial the score as 1.
  3. Since the user may change the chess' position if he or she doesn't think beginning position is not great enough, therefore, the program will temporarily memorize the position which the trainner doen't satisfy.
  4. If (3) exists, then we also break down the pattern square into lines and then check the database whether these patterns exists or not, if the result is yes, then the program will update score, however, this time the score will be reduced 1. On the other hand, the program does nothing.
  5. After single round of the game finished, the application will ask the user whether saves the trainning record in CoreData.
  
### Why is this a ML algorithm?
[![image](https://github.com/ChristianLin0420/Connect6/blob/master/ScoreUpdate.jpg)](https://i.imgur.com/lMP8OZq.mp4)
  As the video shown above, we can change the score table everytime the user trained the program. After tons of trainning, users can train out their own scoring score table.
### Feature of this ML algorithm.
#### Advantage
* Since users have their own strategy, therefore, the patterns they create will be very difference.
#### Disacvantage
* This algorithm needs lots of memory space to store the patterns, thus, I'm still thinking how can I figure out this defect.
## Future Goal
* Can speed up the trainning efficiency
* Using less memory to store same amount of data (Database structure should improve)
* Can compete with others players online
