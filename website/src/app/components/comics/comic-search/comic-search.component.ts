import { Component, OnInit, Input, Output, EventEmitter } from '@angular/core';
import { Series } from 'src/app/models/comics.series.model';
import { StoryArc } from 'src/app/models/comics.storyArc.model';
import { Issue } from 'src/app/models/comics.issue.model';
import { AutoCompleteModule } from 'primeng/autocomplete';
import { StoryLine } from 'src/app/models/comics.story-line.model';
import { ComicsService } from 'src/app/services/comics.service';

@Component({
  selector: 'comic-search',
  templateUrl: './comic-search.component.html',
  styleUrls: ['./comic-search.component.scss']
})
export class ComicSearchComponent implements OnInit {


  //public storyLine:StoryLine;
  private _storyLine:StoryLine;
  set storyLine(value:StoryLine) {
    if(value?.storyLineId > 0) {
      this._storyLine = value;
      this.storyLineFound.emit(this.storyLine);
    }
  }
  get storyLine() {
    return this._storyLine;
  }
  // results: StoryLine[];

  public storyLineNameSearchCriteria:string;

  @Output() storyLineFound = new EventEmitter<StoryLine>();
  
  results: any[];

  constructor(private comicsService:ComicsService) { }

  ngOnInit(): void {

  }

  search(event) {
    let query = event.query;        
    // this.countryService.getCountries().then(countries => {
    //     this.filteredCountriesSingle = this.filterCountry(query, countries);
    // });
      this.comicsService.getStoryLinesPromise(
        this.storyLineNameSearchCriteria
      ).then(storyLines=> {
          this.results = this.filterStoryLine(query, storyLines);
      });    
  }

  // search(event) {
  //     let query = event.query;

  //     this.comicsService.getStoryLinesPromise(
  //       this.storyLineNameSearchCriteria
  //     )    
  //     .then(storyLines => {
  //       this.results = this.filterStoryLine(query, storyLines);
  //       // this.storyLineFound.emit(this.filteredStoryLineSingle[0]);
  //     });
  // }

  // filterStoryLine(query, storyLines: any[]):any[] {
  //     let filtered : any[] = [];
  //     for(let i = 0; i < storyLines.length; i++) {
  //         let storyLine = storyLines[i];
  //         if (storyLine.storyLineName.toLowerCase().indexOf(query.toLowerCase()) == 0) {
  //             filtered.push(storyLine);
  //         }
  //     }
  //     return filtered;
  // }

  filterStoryLine(query, storyLines: any[]):any[] {
    //in a real application, make a request to a remote url with the query and return filtered results, for demo we filter at client side
    let filtered : any[] = [];
    for(let i = 0; i < storyLines.length; i++) {
        let storyLine = storyLines[i];
        if (storyLine.storyLineName.toLowerCase().indexOf(query.toLowerCase()) == 0) {
            filtered.push(storyLine);
        }
    }
    return filtered;
}

  storyLineFoundInternal($event) {
    // this.storyLineFound.emit(this.storyLine);
  }
}
