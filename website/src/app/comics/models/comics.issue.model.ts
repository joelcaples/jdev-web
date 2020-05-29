export class Issue {
  issueId: number;
  seriesId: number;
  issueNumber:number;
  seriesName:string;
  displayValue:string;

  public getDisplayValue(){
    if(this.displayValue)
      return this.displayValue;

    return this.issueNumber?.toString();
  }
}