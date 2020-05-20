import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';

import { AppRoutingModule } from './app/modules/app-routing/app-routing.module';
import { AppComponent } from './app/components/app/app.component';
import { RequestQueueComponent } from './app/widgets/request-queue/request-queue.component';
import { WebScraperComponent } from './app/widgets/web-scraper/web-scraper.component';
import { HttpClientModule } from '@angular/common/http';
import { NgbModule } from '@ng-bootstrap/ng-bootstrap';
import { TechComponent } from './app/components/tech/tech.component';
import { ResourcesComponent } from './app/components/resources/resources.component';
import { WidgetDashboardComponent } from './app/widgets/widget-dashboard/widget-dashboard.component';
import { ComicsComponent } from './app/components/comics/comics.component';
import { FormsModule } from '@angular/forms';

@NgModule({
  declarations: [
    AppComponent,
    RequestQueueComponent,
    WebScraperComponent,
    TechComponent,
    ResourcesComponent,
    WidgetDashboardComponent,
    ComicsComponent
  ],
  imports: [
    FormsModule,
    BrowserModule,
    AppRoutingModule,
    HttpClientModule,
    NgbModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
