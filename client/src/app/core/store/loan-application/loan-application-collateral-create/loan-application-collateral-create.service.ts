import { delay } from 'rxjs/operators';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { environment } from '../../../../../environments/environment';
import { HttpClient } from '@angular/common/http';

@Injectable()
export class LoanAppCollateralCreateService {

  constructor(private httpClient: HttpClient) {
  }

  createCollateral(loanAppId, collateralData): Observable<any> {
    const url = 'loan-applications/' + loanAppId + '/collateral';
    return this.httpClient.post(
      `${environment.API_ENDPOINT}${url}`,
      JSON.stringify(collateralData)
    ).pipe(delay(environment.RESPONSE_DELAY));
  }
}
