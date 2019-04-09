//define var for different scales via substring!
//like: substring(title, "MAG_", "_") and then 10kdistance=0.XXXXX, then setscale distance = 10kdistance


run("Clear Results");
updateResults;
roiManager("reset");
while (nImages>0) {
			selectImage(nImages);
			close();
}
dir1 = getDirectory("Choose image directory "); 		//request source dir via window
list = getFileList(dir1);	
N=0;
CACHE = dir1 + "CACHE" + File.separator;
File.makeDirectory(CACHE);

for (i=0; i<list.length; i++) {						//set i=0, count nuber of list items, enlagre number +1 each cycle, start cycle at brackets
	path = dir1+list[i];
	open(path);
	title = getTitle;		
	saveAs("Tiff", CACHE+title+".tif");
	while (nImages>0) {
			selectImage(nImages);
			close();
}
list2 = getFileList(CACHE);
for (i=0; i<list.length; i++) {						//set i=0, count nuber of list items, enlagre number +1 each cycle, start cycle at brackets
	path = dir1+list[i];							//path location translated for code
	//waitForUser("next file="," "+path+"");
	open(path);
	title = getTitle;										//get title of actual image
		//run("Clear Results");								//to start with an empty results table
		//updateResults;
//conversion
	eightk=matches(title, "MAG_X8000");
	twentyk=matches(title, "MAG_X20k");
	selectWindow(""+title+"");	
	if (eightk==true){
		run("Set Scale...", "distance=0.498 known=1 unit=nm");
		else if (twentyk==true){
			run("Set Scale...", "distance=1.192 known=1 unit=nm");
			else {
				waitForUser("ERROR: wrong magnification in Image "+title+"");
			}
		}
	}
	saveAs("Tiff", dir1+title+"_scaled.tif");
//close all windows to clean up for next round
	{ 
	while (nImages>0) { 
		selectImage(nImages); 
    	close(); } } 
	N=N+1;											//counter for report
}
if(File.exists(CACHE)){
	list = getFileList(CACHE);
		for (i=0; i<list.length; i++)
			ok = File.delete(CACHE+list[i]);
			ok = File.delete(CACHE);
		if(File.exists(CACHE))
			 exit("Unable to delete directory"+CACHE+"");
	}
//report
waitForUser("Summary"," "+N+" files processed");
//JW_27.03.19





