import { Component, OnInit, Input, Output, EventEmitter } from '@angular/core';
import { StoryLine } from 'src/app/models/comics.story-line.model';
import { ComicsService } from 'src/app/services/comics.service';

@Component({
  selector: 'comic-search',
  templateUrl: './comic-search.component.html',
  styleUrls: ['./comic-search.component.scss']
})
export class ComicSearchComponent implements OnInit {

  public storyLineNameSearchCriteria:string;
  public results: any[];
  @Output() storyLineFound = new EventEmitter<StoryLine>();

  constructor(private comicsService:ComicsService) { }

  ngOnInit(): void {

  }

  set storyLine(value:StoryLine) {
    if(value?.storyLineId > 0) {
      this.storyLineFound.emit(value);
    }
  }  

  search(event) {
    let query = event.query;        
      this.comicsService.getStoryLinesPromise(
        this.storyLineNameSearchCriteria
      ).then(storyLines=> {
          this.results = this.filterStoryLine(query, storyLines);
      });    
  }

  filterStoryLine(query, storyLines: any[]):any[] {
    let filtered : any[] = [];
    for(let i = 0; i < storyLines.length; i++) {
        let storyLine = storyLines[i];
        if (storyLine.storyLineName.toLowerCase().indexOf(query.toLowerCase()) == 0) {
            filtered.push(storyLine);
        }
    }
    return filtered;
  }

}
