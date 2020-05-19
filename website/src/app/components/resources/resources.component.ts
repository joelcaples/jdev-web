import { Component, OnInit } from '@angular/core';
import { ComicsService } from 'src/app/services/comics.service';
import { Series } from 'src/app/models/comics.series.model';

@Component({
  selector: 'app-resources',
  templateUrl: './resources.component.html',
  styleUrls: ['./resources.component.scss']
})
export class ResourcesComponent implements OnInit {

  public data:Series[];

  constructor(private comicsService:ComicsService) { }

  ngOnInit(): void {
    this.comicsService.getComics().subscribe(results=>{
      this.data = results;
    },(e=>console.log(e)));
  }

}
