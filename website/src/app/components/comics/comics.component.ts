import { Component, OnInit } from '@angular/core';
import { ComicsService } from 'src/app/services/comics.service';
import { Series } from 'src/app/models/comics.series.model';
import { Issue } from 'src/app/models/comics.issue.model';
import { forkJoin } from 'rxjs';

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

  public selectedSeriesChanged() {
    if(this.selectedSeries.seriesId > 0) {
      this.loadIssues(this.selectedSeries.seriesId);
    }
  }

  public selectedIssueChanged() {
    if(this.selectedIssue.issueId > 0) {

    }
  }
}
