export class Page {
  pageId:number;
  issueId:number;
  pageNumber:number;
  pageFileName:string;
  pageType:number;
  creationDate:Date;
  modificationDate:Date;
  fileId:number;
  displayValue:string;

  public getDisplayValue(){
    if(this.displayValue)
      return this.displayValue;

    return this.pageId?.toString();
  }
}