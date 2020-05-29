export class Issue {
  seriesId: number;
  issueId: number;
  issueNumber:number;
  filePath:string;
  // seriesName:string;
  displayValue:string;

  public getDisplayValue(){
    if(this.displayValue)
      return this.displayValue;

    return this.issueNumber?.toString();
  }
}