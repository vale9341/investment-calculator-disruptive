class ModalCalculator {
  constructor(modal){
    _this = this
    $modal = $(modal)
    $cryptos = $modal.data("cryptos")
    $form = $modal.find("form")
    $tableInformation = $modal.find("#calculator-table")
    $amountInput = $form.find("#amount")
    $cryptoSelect = $form.find("#crypto")
    $btnCalculate = $form.find("#btn-calculate")
    $btnDownloadCsv = $modal.find("#export-csv")
    $btnDownloadJson = $modal.find("#export-json")
    $btnCalculate.on("click", function(){ _this.tableFilling() })
  }

  tableFilling(){
    tbody = $tableInformation.find("tbody")
    tbody.empty()
    investments = this.calculateInvestment()
    this.enableDownloadReport(investments)
    investments.forEach(investment => {
      tbody.append(this.tableRow(investment))
    })
  }

  calculateInvestment(){
    const months = Array.from({ length: 12 }, (_, i) => i + 1)
    let crypto = $cryptos.find((crypto) => crypto["asset_id"] == $cryptoSelect.val())
    let investments= []
    let amountInitial = $amountInput.val()
    months.forEach(month => {
      monthlyPerformance = this.monthlyPerformance(amountInitial, month, crypto)
      amountInitial = monthlyPerformance["capitalAcumulated"]
      investments.push(monthlyPerformance)
    });

    return investments
  }

  monthlyPerformance(amountInitial, month, crypto){
    porcentage = Number(crypto["monthly_percentage"]) / 100
    potential = Math.pow(1 + porcentage, 1)
    capitalFinal = amountInitial * potential
    interestGenerated = capitalFinal - amountInitial
    cryptoPrice = crypto["rate"]
    amountInCrypto = capitalFinal / crypto["rate"]
    return {
      month: month,
      amountInitial: amountInitial,
      monthlyPercentage: crypto["monthly_percentage"],
      interestGenerated: interestGenerated,
      capitalAcumulated: capitalFinal,
      amountInCrypto: amountInCrypto
    }
  }

  tableRow(investment){
    return $("<tr>" +
        `<td>${investment["month"]}</td>` +
        `<td>$${ new Intl.NumberFormat('en-US').format(investment['amountInitial']) }</td>` +
        `<td>%${ new Intl.NumberFormat('en-US').format(investment['monthlyPercentage']) }</td>` +
        `<td>$${ new Intl.NumberFormat('en-US').format(investment['interestGenerated']) }</td>` +
        `<td>$${ new Intl.NumberFormat('en-US').format(investment['capitalAcumulated']) }</td>` +
        `<td>${ investment['amountInCrypto'] }</td>` +
      "</tr>")
  }

  findCrypto(asset_id){
    return $cryptos.find((crypto) => crypto["asset_id"] == asset_id)
  }

  enableDownloadReport(investments){
    this.enableCsvDownload(investments)
    this.enableJsonDownload(investments)
  }

  enableCsvDownload(investments){
    let dataCsv = []
    let titleKeys = [ "Mes", "Monto invertido", "Tasa de Interes", "Interes generado", "Capital acumulado", "Monto en Crypto" ]
    dataCsv.push(titleKeys)
    
    investments.forEach(investment => {
      dataCsv.push(Object.values(investment))  
    })
    
    let csvContent = ''

    dataCsv.forEach(row => {
      csvContent += row.join(',') + '\n'
    })

    const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8,' })
    const objUrl = URL.createObjectURL(blob)

    $btnDownloadCsv.removeAttr("hidden")
    $btnDownloadCsv.attr('href', objUrl)
    $btnDownloadCsv.attr('download', 'calculator.csv')
  }

  enableJsonDownload(investments){
    const dataStr = "data:text/json;charset=utf-8," + encodeURIComponent(JSON.stringify(investments));
    $btnDownloadJson.removeAttr("hidden")
    $btnDownloadJson.attr('href', dataStr)
    $btnDownloadJson.attr('download', 'calculator.json')
  }
}

document.addEventListener("turbolinks:load", function() {
  $("#modal-calculator").each(function(){
    new ModalCalculator(this)
  })
})
