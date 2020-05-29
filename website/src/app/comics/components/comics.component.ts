import { Component, OnInit } from '@angular/core';
import { ComicsService } from 'src/app/comics/services/comics.service';
import { Series } from '../models/comics.series.model';
import { Issue } from '../models/comics.issue.model';
import { StoryArc } from '../models/comics.storyArc.model';
import { SearchResultsRow } from '../models/comics.search-results-row.model';
import { StoryLine } from '../models/comics.story-line.model';
import { ComicsFilter } from '../enums/comics.enums';

@Component({
  selector: 'app-comics',
  templateUrl: './comics.component.html',
  styleUrls: ['./comics.component.scss']
})
export class ComicsComponent implements OnInit {

  private isLoading:boolean=false;

  public seriesList:Series[];
  public selectedSeries:Series;

  public issues:Issue[];
  public selectedIssue:Issue;

  public storyArcs:StoryArc[];
  public selectedStoryArc:StoryArc;

  public storyLines:StoryLine[];
  public selectedStoryLine:StoryLine;

  public searchResults:SearchResultsRow[];
  public selectedSearchResultsRow:SearchResultsRow;

  public columnDefs = [
    {headerName: 'Series', field: 'seriesName', sortable:true },
    {headerName: 'Story Line', field: 'storyLineName', sortable:true },
    {headerName: 'Story Arc', field: 'storyArcName', sortable:true},
    {headerName: 'Start', field: 'firstIssueNumber', sortable:true, maxWidth:90 },
    {headerName: 'End', field: 'lastIssueNumber', sortable:true, maxWidth:90 },
    {headerName: 'Page Count', field: 'pageCount', sortable:true, maxWidth:100 }
  ];
    
  public rowData = [];
  
  private gridApi;
  private gridColumnApi;
  public overlayLoadingTemplate;
  public overlayNoRowsTemplate;

  constructor(private comicsService:ComicsService) { 
    this.overlayLoadingTemplate =
      '<span class="ag-overlay-loading-center">Loading...</span>';
    this.overlayNoRowsTemplate =
      '<span style="padding: 10px; ">no data</span>';    
  }
  
  ngOnInit(): void {
    this.loadSeries();
  }

  onGridReady(params) {
    this.gridApi = params.api;
    this.gridColumnApi = params.columnApi;
    // this.gridApi.hideOverlay();
    this.gridApi.showNoRowsOverlay();
  }

  public loadSeries() {

    this.isLoading=true;
    this.selectedSeries = undefined;

    this.comicsService
      .getComics()
      .subscribe(results => {      
      this.seriesList = results.map(x => Object.assign(new Series(), x));
    },(e=>console.log(e)));

    this.isLoading=false;
  }

  public loadStoryLines(clearValues:boolean) {

    if(clearValues) {
      this.storyLines=[];
      this.selectedStoryLine = undefined;
      return;
    }

    this.isLoading=true;

    this.comicsService.getStoryLines(
      -1, 
      this.selectedSeries?.seriesId, 
      this.selectedIssue?.issueId, 
      -1,
      this.selectedStoryArc?.storyArcId,
      ""
      )
    .subscribe(results  => {
    
      this.storyLines = results.map(x => Object.assign(new StoryLine(), x));
      let selectedStoryLineId = this.selectedStoryLine?.storyLineId ?? -1; 
      this.selectedStoryLine = this.storyLines.filter(function (storyLine) { return storyLine.storyLineId === selectedStoryLineId; })[0] || undefined;

    },(e=>console.log(e)));

    this.isLoading=false;
  }

  public loadStoryArcs(clearValues:boolean) {

    if(clearValues) {
      this.storyArcs=[];
      this.selectedStoryArc = undefined;
      return;
    }

    this.isLoading=true;

    this.comicsService
    .getStoryArcs(
      -1, 
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

  public loadIssues(clearValues:boolean) {

    if(clearValues) {
      this.issues=[];
      this.selectedIssue = undefined;
      return;
    }

    this.isLoading=true;

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

    },(e=>{
      console.log(e);
      this.issues=[];
    }));

    this.isLoading=false;
  }

  public search() {

    this.gridApi.overlay = this.gridApi.overlayLoadingTemplate;

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

    this.gridApi.hideOverlay();
  }

  public selectedSeriesChanged(e) {
    this.selectedSeries = e;    
    this.reload(e, ComicsFilter.Series);
  }

  public selectedIssueChanged(e) {
    this.selectedIssue = e;    
    this.reload(e, ComicsFilter.Issue);
  }

  public selectedStoryLineChanged(e) {
    this.selectedStoryLine = e;    
    this.reload(e, ComicsFilter.StoryLine);
  }

  public selectedStoryArcChanged(e) {
    this.selectedStoryArc = e;
    this.reload(e, ComicsFilter.StoryArc);
  }

  private reload(e, filter:ComicsFilter) {

    let clearValues = (e===undefined && filter===ComicsFilter.Series);

    let p1 = (
        filter!==ComicsFilter.StoryLine)
      ? new Promise(() => this.loadStoryLines(clearValues))
      : new Promise(()=>{return;});

    let p2 = (
        filter!==ComicsFilter.StoryArc) 
      ? new Promise(() => this.loadStoryArcs(clearValues))
      : new Promise(()=>{return;});

      let p3 = (
        filter!==ComicsFilter.Issue)
      ? new Promise(() => this.loadIssues(clearValues))
      : new Promise(()=>{return;});

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

  public foundStoryLineSearchResult(event) {    
    if(event?.storyLineId > 0) {
      this.storyLines=[];
      let storyLine = Object.assign(new StoryLine(), event);
      this.storyLines.push(storyLine);
      this.selectedStoryLine = storyLine;      
      this.selectedStoryLineChanged(storyLine)
    }
  }

  getStoryLineDisplayName(storyLine) {
    if(storyLine !== undefined) {
      return storyLine.storyLineName;
    }
    return "";
  }

  onPageSizeChanged(value) {
    this.gridApi.paginationProxy.setPageSize();
    this.gridApi.paginationSetPageSize(Number(value));
  }

}
