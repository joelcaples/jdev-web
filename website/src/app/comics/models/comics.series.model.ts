export class Series {
  seriesId: number;
  seriesName:string;
  displayValue:string;

  public getDisplayValue(){
    if(this.displayValue)
      return this.displayValue;

    return this.seriesName?.toString();
  }
}