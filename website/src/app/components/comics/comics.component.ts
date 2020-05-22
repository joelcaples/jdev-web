import { Component, OnInit } from '@angular/core';
import { ComicsService } from 'src/app/services/comics.service';
import { Series } from 'src/app/models/comics.series.model';
import { Issue } from 'src/app/models/comics.issue.model';
import { Page } from 'src/app/models/comics.page.model';
import { StoryArc } from 'src/app/models/comics.storyArc.model';
import { SearchResultsRow } from 'src/app/models/comics.search-results-row.model';
import { StoryLine } from 'src/app/models/comics.story-line.model';
import { ComicsFilter } from 'src/app/shared/enums/comics.enums';

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
  }

  public loadSeries() {
    // if(this.isLoading)
    //   return;

    this.isLoading=true;
    this.selectedSeries = undefined;

    this.comicsService
      .getComics()
      .subscribe(results => {
      
      this.seriesList = results.map(x => Object.assign(new Series(), x));

    },(e=>console.log(e)));

    this.isLoading=false;

  }
  public loadStoryLines(reload:boolean) {
    // if(this.isLoading)
    //   return;

    this.isLoading=true;
    // this.selectedStoryLine = undefined;

      this.comicsService.getStoryLines(
        this.selectedPage?.pageId, 
        this.selectedSeries?.seriesId, 
        this.selectedIssue?.issueId, 
        -1,
        this.selectedStoryArc?.storyArcId
        )
    .subscribe(results  => {
    
      this.storyLines = results.map(x => Object.assign(new StoryLine(), x));
      let selectedStoryLineId = this.selectedStoryLine?.storyLineId ?? -1; 
      this.selectedStoryLine = this.storyLines.filter(function (storyLine) { return storyLine.storyLineId === selectedStoryLineId; })[0] || undefined;

    },(e=>console.log(e)));

    this.isLoading=false;
  }

  public loadStoryArcs(reload:boolean) {


    this.isLoading=true;
    // this.selectedStoryArc = undefined;

    this.comicsService
    .getStoryArcs(
      this.selectedPage?.pageId, 
      this.selectedSeries?.seriesId, 
      this.selectedIssue?.issueId, 
      this.selectedStoryLine?.storyLineId, 
      -1)
    .subscribe(results => {    
      this.storyArcs = results.map(x => Object.assign(new StoryArc(), x));
      let selectedStoryArcId = this.selectedStoryArc?.storyArcId ?? -1; 
      this.selectedStoryArc = this.storyArcs.filter(function (storyArc) { return storyArc.storyArcId === selectedStoryArcId; })[0] || undefined;
    },(e=>console.log(e)));
    this.isLoading=false;
  }

  public loadIssues(reload:boolean) {
    // if(this.isLoading)
    //   return;

    this.isLoading=true;

    // console.log("loadIssues (2)");
    // console.log(this.selectedSeries?.seriesId);

    if(this.selectedSeries?.seriesId !== undefined)
      
      this.comicsService
      .getIssues(
        this.selectedSeries?.seriesId, 
        -1,
        this.selectedStoryLine?.storyLineId,
        this.selectedStoryArc?.storyArcId
      )
      .subscribe(results => {
      
      this.issues = results.map(x => Object.assign(new Issue(), x));

      let selectedIssueId = this.selectedIssue?.issueId ?? -1; 
      this.selectedIssue = this.issues.filter(function (issue) { return issue.issueId === selectedIssueId; })[0] || undefined;

    },(e=>console.log(e)));

    this.isLoading=false;
  }

  public loadPages(reload:boolean) {
    // if(this.isLoading)
    //   return;

    this.isLoading=true;
    this.selectedPage = undefined;

    this.comicsService
      .getPages(this.selectedIssue?.issueId)
      .subscribe(results => {

      this.pages = results.map(x => Object.assign(new Page(), x));        

    },(e=>console.log(e)));

    this.isLoading=false;
  }

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

  public selectedSeriesChanged(e) {

    this.selectedSeries = e;

    if(e===undefined)
      this.reload(e, ComicsFilter.Series);
    
    this.applyFilters(e, ComicsFilter.Series);
  }

  public selectedIssueChanged(e) {

    this.selectedIssue = e;

    if(e===undefined)
      this.reload(e, ComicsFilter.Issue);
    
    this.applyFilters(e, ComicsFilter.Issue);
  }

  public selectedPageChanged(e) {

    this.selectedPage = e;

    if(e===undefined)
      this.reload(e, ComicsFilter.Page);
    
    this.applyFilters(e, ComicsFilter.Page);
  }

  public selectedStoryLineChanged(e) {

    this.selectedStoryLine = e;

    if(e===undefined)
      this.reload(e, ComicsFilter.StoryLine);
    
    this.applyFilters(e, ComicsFilter.StoryLine);
  }

  public selectedStoryArcChanged(e) {

    this.selectedStoryArc = e;

    if(e===undefined)
      this.reload(e, ComicsFilter.StoryArc);
    
    this.applyFilters(e, ComicsFilter.StoryArc);
  }

  private reload(e, filter:ComicsFilter) {

    let reload = (e===undefined);

    let p1 = (
        e!==undefined && 
        filter!==ComicsFilter.StoryLine)
      ? new Promise(() => this.loadStoryLines(reload))      
      : new Promise(()=>{return;});

    let p2 = (
        e!==undefined && 
        filter!==ComicsFilter.StoryArc) 
      ? new Promise(() => this.loadStoryArcs(reload))      
      : new Promise(()=>{return;});

      let p3 = (
        e!==undefined && 
        filter!==ComicsFilter.Issue)
      ? new Promise(() => this.loadIssues(reload))
      : new Promise(()=>{return;});

      // let p1 = (e!==undefined && filter!==ComicsFilter.Page)
      // ? new Promise(() => this.loadPages(reload))
      // : new Promise(()=>{return;});

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

  private applyFilters(e, filter:ComicsFilter) {
    this.reload(e, filter);
  }  

}
