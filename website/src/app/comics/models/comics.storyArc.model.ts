export class StoryArc {
  pageStoryArcId:number;
  pageId:number;
  storyArcId:number;
  storyLineId:number;
  storyArcName:string;
  isUnnamed:boolean;
  lastQuickPickDate:Date;
  creationDate:Date;
  modificationDate:Date;
  displayValue:string;

  public getDisplayValue(){
    if(this.displayValue)
      return this.displayValue;

    return this.storyArcName?.toString();
  }
}