import { BrowserModule, HAMMER_GESTURE_CONFIG, HammerModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';

import { AppRoutingModule } from './modules/app-routing/app-routing.module';
import { AppComponent } from './app.component';
import { RequestQueueComponent } from './widgets/request-queue/request-queue.component';
import { WebScraperComponent } from './widgets/web-scraper/web-scraper.component';
import { HttpClientModule } from '@angular/common/http';
import { NgbModule } from '@ng-bootstrap/ng-bootstrap';
import { TechComponent } from './components/tech/tech.component';
import { ResourcesComponent } from './components/resources/resources.component';
import { WidgetDashboardComponent } from './widgets/widget-dashboard/widget-dashboard.component';
import { ComicsComponent } from './components/comics/comics.component';
import { FormsModule } from '@angular/forms';
import { AgGridModule } from 'ag-grid-angular';
import { NavBarComponent } from './components/nav-bar/nav-bar.component';
import { LyHammerGestureConfig, LyThemeModule, LY_THEME, LY_THEME_NAME, StyleRenderer, LyTheme2 } from '@alyle/ui';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { MinimaLight } from '@alyle/ui/themes/minima';

import { CommonModule } from '@angular/common';
import { LyButtonModule } from '@alyle/ui/button';
import { LyMenuModule } from '@alyle/ui/menu';

@NgModule({
  declarations: [
    AppComponent,
    RequestQueueComponent,
    WebScraperComponent,
    TechComponent,
    ResourcesComponent,
    WidgetDashboardComponent,
    ComicsComponent,
    NavBarComponent
  ],
  imports: [
    FormsModule,
    BrowserModule,
    AppRoutingModule,
    HttpClientModule,
    NgbModule,
    AgGridModule.withComponents([]),
    BrowserAnimationsModule,
    HammerModule,
    CommonModule,
    LyButtonModule,
    LyMenuModule
  ],
  providers: [{ provide: HAMMER_GESTURE_CONFIG, useClass: LyHammerGestureConfig }, StyleRenderer, LyTheme2, { provide: LY_THEME_NAME, useValue: 'minima-light' }, { provide: LY_THEME, useClass: MinimaLight, multi: true }],
  bootstrap: [AppComponent]
})
export class AppModule { }
