import { Component, OnInit } from '@angular/core';
import { ComicsService } from 'src/app/services/comics.service';
import { Series } from 'src/app/models/comics.series.model';
import { Issue } from 'src/app/models/comics.issue.model';
import { forkJoin } from 'rxjs';
import { Page } from 'src/app/models/comics.page.model';
import { StoryArc } from 'src/app/models/comics.storyArc.model';

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
      defaultSeries.seriesId=0;
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
      defaultIssue.issueId=0;
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
      defaultPage.issueId=0;
      //defaultIssue.="Select...";
      this.pages.push(defaultPage);
      this.selectedPage = defaultPage;
      this.pages = this.pages.concat(p);

    },(e=>console.log(e)));
  }

  public loadStoryArcs(pageId:number) {

    forkJoin(
    [ 
      this.comicsService.getStoryArcs(pageId)
    ])
    .subscribe(([sa]: [StoryArc[]])  => {
    
      this.storyArcs = [];
      let defaultStoryArc = new StoryArc();
      defaultStoryArc.storyArcId=0;
      //defaultIssue.="Select...";
      this.storyArcs.push(defaultStoryArc);
      this.selectedStoryArc = defaultStoryArc;
      this.storyArcs = this.storyArcs.concat(sa);

    },(e=>console.log(e)));
  }

  public selectedSeriesChanged() {
    if(this.selectedSeries.seriesId > 0) {
      this.loadIssues(this.selectedSeries.seriesId);
    }
  }

  public selectedIssueChanged() {
    if(this.selectedIssue.issueId > 0) {
      this.loadPages(this.selectedIssue.issueId);
    }
  }

  public selectedPageChanged() {
    if(this.selectedPage.pageId > 0) {
      this.loadStoryArcs(this.selectedPage.pageId)
    }
  }

  public selectedStoryArcChanged() {
    
  }
}
