import { Component, OnInit } from '@angular/core';
import { ComicsService } from 'src/app/services/comics.service';
import { Series } from 'src/app/models/comics.series.model';
import { Issue } from 'src/app/models/comics.issue.model';
import { forkJoin } from 'rxjs';
import { Page } from 'src/app/models/comics.page.model';
import { StoryArc } from 'src/app/models/comics.storyArc.model';
import { SearchResultsRow } from 'src/app/models/comics.search-results-row.model';
import { StoryLine } from 'src/app/models/comics.story-line.model';
import { promise } from 'protractor';

@Component({
  selector: 'app-comics',
  templateUrl: './comics.component.html',
  styleUrls: ['./comics.component.scss']
})
export class ComicsComponent implements OnInit {

  public seriesList:Series[];
  public selectedSeries:Series;
  public issues:Issue[];
  public selectedIssue:Issue;
  public label:string;
  public pages:Page[];
  public selectedPage:Page;
  public storyArcs:StoryArc[];
  public selectedStoryArc:StoryArc;
  public searchResults:SearchResultsRow[];
  public selectedSearchResultsRow:SearchResultsRow;
  public storyLines:StoryLine[];
  public selectedStoryLine:StoryLine;
  private isLoading:boolean=false;
  constructor(private comicsService:ComicsService) { }

  ngOnInit(): void {
    this.label="Series";
    this.loadSeries();
    // this.storyArcs.splice(0,0,this.defaultStoryArc());
    // this.issues.splice(0,0,this.defaultIssue());
    // this.pages.splice(0,0,this.defaultPage());
    // this.storyLines.splice(0,0,this.defaultStoryLine());
    // this.storyArcs.splice(0,0,this.defaultStoryArc());
  }

  public loadSeries() {
    if(this.isLoading)
      return;

    this.isLoading=true;

    this.comicsService
      .getComics()
      .subscribe(results => {
      
      this.seriesList = results.map(x => Object.assign(new Series(), x));

      // let defaultSeries = new Series();
      // defaultSeries.seriesId=-1;
      // defaultSeries.displayValue="Select...";
      // this.selectedSeries = defaultSeries;      
      // this.seriesList.splice(0,0,defaultSeries);

    },(e=>console.log(e)));

    this.isLoading=false;

  }

  public loadIssues() {
    if(this.isLoading)
      return;

    this.isLoading=true;

    console.log("loadIssues (2)");
    console.log(this.selectedSeries?.seriesId);
    if(this.selectedSeries?.seriesId !== undefined)
    this.comicsService
      .getIssues(this.selectedSeries.seriesId)
      .subscribe(results => {
      
      this.issues = results.map(x => Object.assign(new Issue(), x));
      // this.issues.splice(0,0,this.defaultIssue());

    },(e=>console.log(e)));

    this.isLoading=false;
  }

  // private defaultIssue() {
  //   let defaultIssue = new Issue();
  //   defaultIssue.issueId=-1;
  //   defaultIssue.displayValue="Select...";
  //   this.selectedIssue = defaultIssue;
  //   return this.selectedIssue;
  // }

  public loadPages(issueId:number) {
    if(this.isLoading)
      return;

    this.isLoading=true;

    this.comicsService
      .getPages(issueId)
      .subscribe(results => {

      this.pages = results.map(x => Object.assign(new Page(), x));        
      // this.pages.splice(0,0,this.defaultPage());

    },(e=>console.log(e)));

    this.isLoading=false;
  }

//   private defaultPage() {
//     let defaultPage = new Page();
//     defaultPage.issueId=-1;
//     defaultPage.displayValue="Select...";
//     this.selectedPage = defaultPage;
//     return this.selectedPage;
// }

  public loadStoryLines() {
    if(this.isLoading)
      return;

    this.isLoading=true;

      this.comicsService.getStoryLines(
        this.selectedPage?.pageId, 
        this.selectedSeries?.seriesId, 
        this.selectedIssue?.issueId, 
        -1, 
        -1)
    .subscribe(results  => {
    
      this.storyLines = results.map(x => Object.assign(new StoryLine(), x));
      // this.storyLines.splice(0,0,this.defaultStoryLine());

    },(e=>console.log(e)));

    this.isLoading=false;
  }

  // private defaultStoryLine() {
  //   let defaultStoryLine = new StoryLine();
  //   defaultStoryLine.storyLineId=-1;
  //   defaultStoryLine.displayValue="Select...";
  //   this.selectedStoryLine = defaultStoryLine;
  //   return this.selectedStoryLine;
  // }

  public loadStoryArcs(reload:boolean) {

    console.log("===== loadStoryArcs =====")
    console.log("isLoading:" + this.isLoading);
    console.log("reload:" + reload);

    if(this.isLoading)
      return;

    this.isLoading=true;

      this.comicsService.getStoryArcs(
        this.selectedPage?.pageId, 
        this.selectedSeries?.seriesId, 
        this.selectedIssue?.issueId, 
        -1, 
        -1)
    .subscribe(results => {    
      this.storyArcs = results.map(x => Object.assign(new StoryArc(), x));
      // this.storyArcs.splice(0,0,this.defaultStoryArc());
    },(e=>console.log(e)));
    this.isLoading=false;
  }

  // private defaultStoryArc() {
  //   let defaultStoryArc = new StoryArc();
  //   defaultStoryArc.storyArcId=-1;
  //   defaultStoryArc.displayValue="Select...";
  //   this.selectedStoryArc = defaultStoryArc;
  //   return this.selectedStoryArc;
  // }

  public search() {

    this.comicsService
      .search(
        this.selectedSeries === undefined ? -1 : this.selectedSeries.seriesId, 
        this.selectedIssue === undefined ? -1 : this.selectedIssue.issueId, 
        this.selectedStoryArc === undefined ? -1 : this.selectedStoryArc.storyArcId, 
        this.selectedStoryLine === undefined ? -1 : this.selectedStoryLine.storyLineId 
        )
      .subscribe(results  => {
    
        this.searchResults = results.map(x => Object.assign(new SearchResultsRow(), x));
        this.searchResults = this.searchResults.concat(results.slice(0,50));

    },(e=>console.log(e)));
  }

  // compareSeries(arg1, arg2) {
  //   if (arg1.se && arg2) {
  //     return arg1.seriesId == arg2.seriesId;
  //   } else {
  //     return false;
  //   }
  // }

  public selectedSeriesChanged(e) {
    // console.log(e);
    // console.log(e.target);
    // console.log(e.target.value);
    this.selectedSeries = e;
    let reload = (e === undefined);
    // console.log("selctedSeriesChanged (1)");
    // console.log(this.selectedSeries?.seriesId);
    // if(this.selectedSeries.seriesId > 0) {
      this.loadIssues();
    // }
    this.loadStoryArcs(reload);
    this.loadStoryLines();
    this.search();
  }

  public selectedIssueChanged(e) {
    // bug?  Should be just the obj?
    this.selectedIssue = e;
    let reload = (e === undefined);
    let p1 = new Promise(() => this.loadPages(this.selectedIssue.issueId));
    let p2 = new Promise(() => this.loadStoryArcs(reload));
    let p3 = new Promise(() => this.loadStoryLines());
    let p4 = new Promise(() => this.search());

    p1
    .then(()=>
      p2
      .then(()=>
        p3
        .then(()=>
          p4
          .catch(err=>console.log(err))
        .catch(err=>console.log(err)))
      .catch(err=>console.log(err)))
    .catch(err=>console.log(err)))
    }

  public selectedPageChanged(e) {
    this.selectedPage = e;
    this.search();
  }

  public selectedStoryLineChanged(e) {

    this.selectedStoryLine = e;
    let reload = (e === undefined);

    let p1 = new Promise(() => this.loadPages(this.selectedIssue?.issueId));
    let p2 = new Promise(() => this.loadStoryArcs(reload));
    let p4 = new Promise(() => this.search());

    p1
    .then(()=>
      p2
      .then(()=>
        p4
        .catch(err=>console.log(err))
      .catch(err=>console.log(err)))
    .catch(err=>console.log(err)))
  }

  public selectedStoryArcChanged(e) {
    this.selectedStoryArc = e;
    let p1 = new Promise(() => this.loadPages(this.selectedIssue.issueId));
    let p3 = new Promise(() => this.loadStoryLines());
    let p4 = new Promise(() => this.search());

    p1
    .then(()=>
      p3
      .then(()=>
        p4
        .catch(err=>console.log(err))
      .catch(err=>console.log(err)))
    .catch(err=>console.log(err)))
  
  }

}
