# Pipilined сумматор чисел с плавающей точкой
  Данный модуль реализует конвейерный (pipeline) сумматор чисел в формате IEEE-754 одинарной точности. Операнды и результат представлены структурой float_point_num (из float_types_pkg) с полями: знак (1 бит), порядок (8 бит) и мантисса (24 бита, включая неявный ведущий 1). Процесс сложения разбит на несколько стадий: выравнивание порядков, суммирование мантисс и нормализация результата. В первой стадии (fetch_stage) неявный бит «1» явным образом добавляется к мантиссе каждого входного числа (если сигнал valid_i активен). Кроме того, на этой стадии определяется статус операции: если оба входа нулевые, выставляется код ZERO_res; если хотя бы одна экспонента равна «11111111», – INF_OR_NAN; иначе – OK_state.

## Описание главного модуля pipelined_fp_summator

  ```sv
    module pipelined_fp_summator import float_types_pkg::*;
  input  logic           clk_i,
  input  logic           rst_i,
  input  float_point_num a_i,
  input  float_point_num b_i,
  input  logic           vld_i,
  output float_point_num answer_o,
  output logic [1:0]     num_status_o
  );
  endmodule
  ```


  [ссылка в drawio](https://viewer.diagrams.net/index.html?tags=%7B%7D&lightbox=1&highlight=0000ff&edit=_blank&layers=1&nav=1&title=pipiline_fpu_summator.drawio&dark=auto#R%3Cmxfile%3E%3Cdiagram%20name%3D%22%D0%A1%D1%82%D1%80%D0%B0%D0%BD%D0%B8%D1%86%D0%B0%20%E2%80%94%201%22%20id%3D%22OFzG4s3xbjuP8PP5mnqq%22%3E7R1bc5s6%2Btd4ZvchHgkhLo9x2p7dOb1NszM9PS8eYpOYLTZeIE3SX78SRoAuxtgGQYLz0BoBMv7udyboZv38R%2BxtV5%2BipR9ODLB8nqB3E8MwHGyQ%2F%2BjKy24FYpCvPMTBMl8rF26D336%2BCPLVx2DpJ9yFaRSFabDlFxfRZuMvUm7Ni%2BPoib%2FsPgr5b916D760cLvwQnn1e7BMV7tVx7DL9X%2F5wcOKfTO03N2Ztccuzn9JsvKW0VNlCb2foJs4itLdp%2FXzjR9S6DG47O77sOds8WCxv0mb3PD90531fBN8d2%2F964c%2FvnxPgh%2BrKwis3T6%2FvPAx%2F8n546YvDAZx9LhZ%2BnQbOEGzp1WQ%2Brdbb0HPPhG0k7VVug7z0%2FJj5U%2F6y49T%2F7mylD%2FmH3609tP4hVzCyAbkIHvhaeGpRIAB3XxxVYU%2BsPNVL0f7Q7F5CRnyIQeOGlBP26s%2Fb%2Fzte%2BPLf%2Bbb5W04n%2F%2F9%2FgpiS4KLvySkkh9GcbqKHqKNF74vV2cl5AA5Kq%2F5GEXbHF7%2F9dP0Jad77zGNeGjeB2F4E4VRnH0j8ghoDEzWkzSOfvrsTEhBcLX04p%2F%2FIBdZHwCgECQ%2FFLku%2FfzP4g5GwyZZ8Z%2BD9K%2F8e%2BjnH%2FQxpzg%2FevecP3V28JIf7MVuEj3GC78OgDC%2FkkKtlgpiP%2FTS4BfPgCqE5rd%2BjQLyMAX1YFugHkegid2j5ndVGUbYyHb5jSxT2Cj14gc%2FlTbK6Kv4PeeQHO6D5Ahm45e%2FGPLpwY4wbMyOS9LIjhht1NEkACVN0k8fPsg0iXqgSTNXKRkm6640kR7qlWQfPJF6IYYut5Ph4q7IV61aoKxJeiTfQ9R7BhU1pCHcOgmdp9EOK36yC7Gz%2FMNK30u2O%2BPrPnimyOP0Fi8JrncqTKmdKpouV2Jkp2iTVtbvs7927AzoQo5DELQlQwMqzYyOUOL2YmPo5xijKcfgToTudRx7L5ULtlQEJjUy2eJlsmngWtErXo9cLJDG7glaFrfmaIlHCRDGTK%2BceFwHtEo8dTDVrQveY2jKnso%2BiS%2FpiJmR64hWdIGIJtnp7EoX7OFnKOPgLfIzaqoMzEGZT%2BhiPgksg7DTr%2FlkNkDJZnlNo4LkaBF6SRIseEzw%2FHMqMwhRGwt4LjEtFWgy3tkWKH1n5glbdQg67Ks25JMKmrACTWztTIcWCTY2Q8qx%2Fqxgqxuuze%2FTcTAGS7QVRsHDgixN8Iz8RnRNPpBly1tT5t7cJfQ%2Fbx5IJEi4KxXYn7D4hlIkQbVPKGNGeTBYeOF1fmIdLJc78e4nwW%2FvLtuKkk1ufJB98Yx%2BPdmLSPRkJ9yhRHGbaOML5JkvtSAOTINHkIMV0kBBZ6grcdAgsj0GcWAMSxyoreHjw1s2FDbSKw9sibh%2BhcsxcbvNi3VXNpdVVNQZszsXZq9YpcNkdmSh6ans7ohb6WV3t6H6B3cjkgGiaYdULrNOIcA8iyEls20hnlPEdypQQobKTeosl40vvquNBaworVUFUjrDSRPndVw4Qaa%2BEFxt%2BuGCk1o7Ty9Omnh1bxsnEDgDE14QuDIStBdHAeB4FYOaO4Pt%2BkTBwSg1zu3Nrus%2FILRFKdhZ2UbtD70w2JA0URP3dmxI6V0VyU7hxLBC6urdkQ8PafbDdwsUMBy6rP89RuzE1c59uyYXQHv7vLstP882%2BuCni1W2Ay1Yznclj73bmP8yslx5gBadURVh8VK8BUQ7TODVuZWmTrfSkm3zMQX2bUEjEaNQQohefMh2%2BbiCr7YlsIgjs4jW6KslW%2BVjCoSJHKISWXo5RDbivDkYDT4gQEMTWbIBdzdmhPTPIbLxtnlcz4l5lT4m8%2Bj1mU0QCJ0DSEHztgLEYldLeyk5WU3fh5GXzjPKnBNwS1BOnoJ16O0IkRi2LH5AQbRYBeHyo%2FcSPdLnJnha%2FGRHs1UUB7%2FJ9V5YkLYXp3ncAAHuilt6Z75nxjL%2BVwZ2KCx98p65Cz96ScqeJgpDb5sEO3ajN66JWx5sZlGaRuv8Ig2dcnwGxgINTWVo1CA9%2F7ZvxEn0Ng%2FkB5atVTyFOQoKg6gBF3sh4ZiNl%2FozygWJRGkthDEcVZyQL86ZUCDwS2H0ECwaXNd4KclEwV4vrKkIZrIm9O%2FTOkmTEGILNg8fs8uyJr985VuODLoUkdsJI9I8%2BIrc6G8kZTGjNbk01U1TmjfkGJbHmSbZRjHx8zfk8b0gI16fsMaTT9mDSDYiQyt66GguqBcmh3njhSe63txGRxVJa0qCNK9s76kqI2f95%2B2FrHohK0X6VjNZqWKBx5CVgcpyhbW3qYsSXQipO0JShS%2B1EhI0esnalIVVZS3Vj0m1lKpRYdXSAcBGEo3SoDUGwDyzpRM0LrZme%2FbcZgQNoRrfsK0qhRy%2BASNQe4Np47rru2lMKhDBRTLud8FwgXZ5yjzA1pkUCCIqndy2PDAoFpVge6rwwewpgyTH5rZYG9dietZQqAxR4sfBztrvB3QOnLLUPoMeQlPWQs7JyKmFZPCxX9Q%2B8Jj8fZVSstOcOASNxycwf7N3KSm25ubp7v1SUrgBW%2FVSEju47vqupKScobobsJScEuLj0YCcqYkwKP6sQYjNBvVfQxCbAiyJhAS4FpYdylB1K3Yvg2wEUXjvWY5aFN7YlPQmYiW%2ByYth03Y4QTwFRDvVC%2BPs6KsfBwSMNERczK7RN%2BKGVY701S4vS1RkUP4v%2FwyOel0EppbYFLSn5EkhrYHD7WYioU1gT7%2FB0XoE7GkX3%2FtkRYm3%2BoaO9ALs23axHKPKNPAUhtHp%2BDEb9LBFA1r3%2B85TVtDpF9W8bDSObJNqdbDdGRYtbOz3Dw7%2Fl3lOBoNBMTtN4T5qrYtmDzD2tsTmwx%2F1NCZikVCamQmKam1%2BI1ewoLueEAnlTq44SSUSe6tlJQzcLB%2Fdc01JQUbD0ME65nWeo2obB4%2BYizAYVXvp1St0JpOgVu%2Bqtkmz3ihUbdM5WZpUrUgoJ6taYSM2b0abrpUrihbhz%2FHoWsFk6ruAE7LxxkNq9keuyUFJVZDHErN86LXDLH%2BDoQhvXFthoXUM9906VlQNjBgppj00pJg9m%2B98pvdQrFRrPQwjzwaD8gdmrLMnHzGnWQKnWTaeor7tdbPnePVZzNZtWYXRdCQuNIc1E7d48guzFcxmY2tqKPok9Jobqg7m8bSfWUL3mWUpBaDm6ls5YDGmlkARJ7ap5BPNOJF9%2FDF1%2BpuYLyVSua%2BaESL30IypsVys7RoAQpTdJx0NPcm6U8gGq%2BB%2Bt9Fbn31iikJR1dDJ%2Bsr0IJzpySGF2VyhmErFFkgV0%2B4SThfT14UD9DPRJVnnQl6L2KoeRq1IYdXHep3%2FvaA87JKjHIKHXfL2BwWeSf%2BXIabQEANgljNlpTP98YACD8MNgJ3DO41ratlEvcHwzmXYrMQ7xUTg%2FjR6B3MXCZTULsgtnVIDbt%2B85%2BEKfWuWayh6Vw2gyF2LA2pbzBH03KA%2BOafup9uEHEuzHRaqzDHRL1SVfUZGL6ZfRe3Zw82yqpCqBuIw2mkdoTnW4t9VevB6J1f43TZBMahyQd08prQ3kNFPc6yN4bRIDBTGaqXHs9%2BGWLNBjKPXhljbMaaWqMkIRKBT9sNC2XzRPVKAmVCD0GvHCcBuM99m45pwNLDMtymHme6GLGQQEBmiyMMRww9IZ3sWPEPvxM8Ej8sDEjpEltcBUr%2FckeX3mNKbUtrAUvk4evNpivc%2BjSnB6QrGjiq60BVC1K9df1UtXJJyxsC%2FVytn%2BG52U4ezgz4H62XtfECEKbEp4vdoa4gDBqbyi9pyR5RgdHr2f48jMDasBEyR5UzKgSVXdIaHMambWUIPDoxyOIdeDxuTLBNzkLJZiqQHygbdULbpqllob3OVeAOyjVZZoR5D1fZlP5lnQ5OHZjVDZMlzqyxsTpVz1vWbyE1eEdXvsCrkysOqLMOdum5PzrlazQ1qjkr7vabnCFS3qanQesj5RAVviLkrs14MSjdASyCoTsSgnNCiYnBX%2FTZIMQj3je%2ByEZ4i%2BWy%2FopFp2YGLRnsvUCGYunLAps9IAnslWq8T%2FVodGnXyJCu98%2FyOmFDFLIKuzVqL%2BcxF0Sq%2FQ%2BMOf1OsHxS9%2FD0t%2Fsebx4Ljxwa3dCvmmekzDMvC1jEeRjdvNE4f6OKNXUJqX6zdPZVTbAdOLX7UpSG%2B0qe9eRhqG09ps1DXreW3Zw05fKmaW25hd8pmU1RUtKMzimnsNShHhRzbEpFjK97k7OrETIMMuu5uCli0TxzfTlH27LUOKVXd%2FrmNRm6jRqMjyvx2a8vgl7jU%2FjOKb%2FQ5vhuqWOOet0VpoOdFh5bwIhLLdlT5bK5sUTXfqivCVeWqj6OBOjKdJ7QidQ%2FWxyLZRYml6pNTveuyM7GufNtghqNk620a8f2%2BCuQyIl4gfbfn2JFumXLg3dKJdNVLloMpfTXfaHFi28oufq1okRMh3iZ58uMxmb6O2PHEimD78kj292zsFZAUOVfUirhaR8tcSuZGhSwll%2F4mitdBSMA9TzIvZ%2BTS0jEFzlS9D1XVuNNdaY3slUroeOvdVFhMzGOtnYi12boLXiZCyqVnvFw612W8OFqnaanti74n1x3XwbQXDdV4upoAFU3vaoi0%2Fu6o8xjn0vIOXSwqGtkA1Ms1vRTWynneZjnkKprOYCBF5%2FurYKBL37vEQKrMgVYGMnopuRhYM3RtN%2BzhurTWm8ZOrD8Q%2B2AR1wd7%2BAY7n8bfbaX6oOoVXiXBmfCNEJyZv2qpU4JTvKnAm4fKgOpAyiB5oBqgqMLTVfCohqNcmyEBcAj1joJIU3t2msu%2FFVN5a4hPV4JeKIxDrOKumqBX5TgNNiun%2FTqGi48lJT%2BQZU1ZcKAvKxHJSaljM5GHss%2B0PXXkwXWRIYvK1b7yz6hB98%2FY2NE0jCnqmR1N2aRpvTDgwo%2BygsRKSayVJc0GVtjoWNKRDRe9%2FKicgDGymg1RedkyUvQWbPQ85q%2FS49NtQkU13ug1xIMVw41GJ8rE4eaqtm%2B9ouyEmsOjSmrKqqmRWxcOEv08GfVai6mwyrQ4t%2B7c2WNmfo7itUfrqiZjeAMHtFzRtTNkPterHvtJ%2FBSTX1i7XjEtcP%2FIF6ZSr8DUBPaED%2BBbxgHFmh0dGBkzkAkHqJv%2BQf0TDsz8hT7dZpL2q6qz22Kg2Bczob%2FwLS2Bpu0eycrb0o8pkY3%2B74iiZLatsFOxXuGxQ9ZaZqTdlnq3i2yA6%2FJNeiajl2oLj6r%2FzOkqCwDBq0q2n%2B6RMGV3UOC5vb3WpPa5pSJ%2FCW19ZwrLxuycujGAqrCk%2FjShO%2FQ0IYGV1F2tClbozhG6Cu9X75tbHIcXEK57iml1uthwmha2MT4ditjoZfjiK56k0fV8DCxEVWDDiYjSRmXIsjAi9M7DcN%2FeRKR%2BBht1PoVTbME5meLs0yjuWCdP%2BqK2xxXtMYFfc%2FnfvUen7qjCBDc2wpUzVYI%2FXR%2B6jfWh2wmRH09SgrR0D7y5RbqBZfY6pUFXjhuwdwHH%2FgP5F5Uxyb1mv6YaLUPot3RV9eJsZhPnxHbWcqsqBRI5%2Bm1nbcgDCM4XxIqR%2F1rzNm6TUp3NkrBT9ESOFqGXJMFCdLaqYlaQfT6GpkL28UiaGaURcHOjNgKsLo2A86IMFeSpAkNs7UxTwcDsbWWMfBAQ3fHG5gJ2hL0Maa%2BjDYbWjVhVm%2F7YRYbbu8iAQA53XWTGsSZVTzLDgu3JDGJ1DU5mQKCKI7ZZiLB5XM%2BJlZc%2BJpdiBEOcXYstRymetE72YAOrKyQQRsHDgiwRmCECo2tAIScnu0Y3mocgkG8bUtZE6n3nEZA9hZLnJMwkT8E69HYgInqYBQQooBerIFx%2B9F6iR%2FrM5P7FT3Y0W0Vx8Jtc75VhUS9O80AAAtwVt%2FTOfM8Mmf5XBnMoLH3ynrkLP3pJyp4mCkNvmwQ7QqA3romwDDazKE2j9aRRRqgNjPP4tm1j6sgzCpUoh%2BJQ3xZxLrshX%2F7MUO6rctL0AsCEisymTRmI8XDo36d1HExk%2ByLYPHzMLsuCM%2FnKtxw4dCkit9%2BHmcWzIjf6G4nVae78hqpMKntuyDEsjzM5sI1iYkhuyON7QYZgn5DPk59k9fU0o1WRIkdTygFmO0xArN5MEUnQLCBkv%2BDfnz%2FMo3j%2B%2BfrzjjyYVLvQhlbasHqnDSj7Jn%2B%2F%2F%2FZlTsRxITjgRXD0QRxud8RBDuOIWumlK0F%2B2OoTsebpFf8H%3C%2Fdiagram%3E%3C%2Fmxfile%3E#%7B%22pageId%22%3A%22OFzG4s3xbjuP8PP5mnqq%22%7D)



## Описание модуля fetch_stage


  ```sv
  module fetch_stage import float_types_pkg.*;
  input  logic           valid_i,
  input  float_point_num a_i,
  input  float_point_num b_i,
  output float_point_num a_o,
  output float_point_num b_o,
  output logic [1:0]     num_status
  );
  endmodule
  ```



### типы чисел

| Тип               | Exp    | Mantissa | Особенности               |
| ----------------- | ------ | -------- | ------------------------- |
| Обычное число | 1..254 | любая    | Скрытая 1, нормализация   |
| Ноль          | 0      | 0        | ±0, без скрытой 1         |
| Denormal      | 0      | ≠0       | нет скрытой 1, exp = -126 |
| ∞             | 255    | 0        | ±∞                        |
| NaN           | 255    | ≠0       | Не число (NaN)            |

---

### Выбор знака итоговой суммы

|знаки|a > b|a<b|
|-----|-----|---|
|-a,b | -   | + |
|a,-b | +   | - |
