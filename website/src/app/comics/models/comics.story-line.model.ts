export class StoryLine {
  storyLineId:number;
  storyLineName:string;
  displayValue:string;

  public getDisplayValue(){
    if(this.displayValue)
      return this.displayValue;

    return this.storyLineName?.toString();
  }
}