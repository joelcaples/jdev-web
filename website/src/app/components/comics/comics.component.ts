import { Component, OnInit } from '@angular/core';
import { ComicsService } from 'src/app/services/comics.service';
import { Series } from 'src/app/models/comics.series.model';
import { Issue } from 'src/app/models/comics.issue.model';
import { forkJoin } from 'rxjs';
import { Page } from 'src/app/models/comics.page.model';
import { StoryArc } from 'src/app/models/comics.storyArc.model';
import { SearchResultsRow } from 'src/app/models/comics.search-results-row.model';

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

  constructor(private comicsService:ComicsService) { }

  ngOnInit(): void {
    this.label="Series";
    this.loadSeries();
  }

  public loadSeries() {
    this.label="Series";

      forkJoin(
      [ 
        this.comicsService.getComics()
      ])
      .subscribe(([s]: [Series[]])  => {
      
      this.seriesList = [];
      let defaultSeries = new Series();
      defaultSeries.seriesId=-1;
      defaultSeries.seriesName="Select...";
      this.seriesList.push(defaultSeries);
      this.selectedSeries = defaultSeries;
      this.seriesList = this.seriesList.concat(s);

    },(e=>console.log(e)));

  }

  public loadIssues(seriesId:number) {

      forkJoin(
      [ 
        this.comicsService.getIssues(seriesId)
      ])
      .subscribe(([i]: [Issue[]])  => {
      
      this.issues = [];
      let defaultIssue = new Issue();
      defaultIssue.issueId=-1;
      //defaultIssue.="Select...";
      this.issues.push(defaultIssue);
      this.selectedIssue = defaultIssue;
      this.issues = this.issues.concat(i);

    },(e=>console.log(e)));
  }

  public loadPages(issueId:number) {

    forkJoin(
    [ 
      this.comicsService.getPages(issueId)
    ])
    .subscribe(([p]: [Page[]])  => {
    
      this.pages = [];
      let defaultPage = new Page();
      defaultPage.issueId=-1;
      //defaultIssue.="Select...";
      this.pages.push(defaultPage);
      this.selectedPage = defaultPage;
      this.pages = this.pages.concat(p);

    },(e=>console.log(e)));
  }

  public loadStoryArcs() {

    forkJoin(
    [ 
      this.comicsService.getStoryArcs(
        this.selectedPage?.pageId, 
        this.selectedSeries?.seriesId, 
        this.selectedIssue?.issueId, 
        -1, 
        -1)
    ])
    .subscribe(([sa]: [StoryArc[]])  => {
    
      this.storyArcs = [];
      let defaultStoryArc = new StoryArc();
      defaultStoryArc.storyArcId=-1;
      //defaultIssue.="Select...";
      this.storyArcs.push(defaultStoryArc);
      this.selectedStoryArc = defaultStoryArc;
      this.storyArcs = this.storyArcs.concat(sa);

    },(e=>console.log(e)));
  }

  public search() {

    forkJoin(
    [ 
      this.comicsService.search(
        this.selectedSeries?.seriesId === null ? -1 : this.selectedSeries.seriesId, 
        this.selectedIssue?.issueId === null ? -1 : this.selectedIssue.issueId, 
        // this.selectedStoryArc?.storyArcId === null ? -1 : this.selectedStoryArc.storyArcId, 
        -1,
        -1)
    ])
    .subscribe(([sr]: [SearchResultsRow[]])  => {
    
      this.searchResults = [];
      this.searchResults = this.searchResults.concat(sr.slice(0,50));

    },(e=>console.log(e)));
  }

  public selectedSeriesChanged() {
    if(this.selectedSeries.seriesId > 0) {
      this.loadIssues(this.selectedSeries.seriesId);
    }
    this.loadStoryArcs();
    this.search();
  }

  public selectedIssueChanged() {
    if(this.selectedIssue.issueId > 0) {
      this.loadPages(this.selectedIssue.issueId);
    }
    this.loadStoryArcs();
    this.search();
  }

  public selectedPageChanged() {
    this.loadStoryArcs();
    this.search();
  }

  public selectedStoryArcChanged() {
    this.search();
  }

}
