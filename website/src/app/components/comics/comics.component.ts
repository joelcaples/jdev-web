import { Component, OnInit } from '@angular/core';
import { ComicsService } from 'src/app/services/comics.service';
import { Series } from 'src/app/models/comics.series.model';

@Component({
  selector: 'app-comics',
  templateUrl: './comics.component.html',
  styleUrls: ['./comics.component.scss']
})
export class ComicsComponent implements OnInit {

  public seriesList:Series[];
  public selectedSeries:Series;
  public label:string;

  constructor(private comicsService:ComicsService) { }

  ngOnInit(): void {
    this.label="Series";
    this.comicsService.getComics().subscribe(results=>{
      
      this.seriesList = [];

      let defaultSeries = new Series();
      defaultSeries.seriesId=0;
      defaultSeries.seriesName="Select...";
      this.seriesList.push(defaultSeries);
      this.selectedSeries = defaultSeries;

      this.seriesList = this.seriesList.concat(results);

    },(e=>console.log(e)));
  }

}
