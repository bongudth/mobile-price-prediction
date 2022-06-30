<template>
  <v-app>
    <v-app-bar app color="primary" dark>
      <div class="d-flex align-center">
        <v-img
          alt="Vuetify Logo"
          class="shrink mr-2"
          contain
          src="image/Mobile-Smartphone-icon.png"
          transition="scale-transition"
          width="40"
        />
      </div>
      <v-toolbar-title class="caption"> Mobile Price Predict </v-toolbar-title>
    </v-app-bar>

    <v-main>
      <div class="container">
        <v-form ref="form">
          <v-alert v-if="error" type="error">Wrong input!</v-alert>
          <v-select
            :items="scr_typ"
            v-model="scr_typ_selected"
            label="Screen type"
            item-text="disp"
            item-value="val"
            required
          ></v-select>
          <v-select
            :items="oses"
            v-model="os_selected"
            label="OS"
            item-text="disp"
            item-value="val"
            required
          ></v-select>
          <v-select
            :items="chips"
            v-model="chip_selected"
            label="Chipset"
            item-text="disp"
            item-value="val"
            required
          ></v-select>
          <v-select
            :items="nets"
            v-model="net_selected"
            label="Mobile Network"
            item-text="disp"
            item-value="val"
            required
          ></v-select>
          <v-select
            :items="resolutions"
            v-model="resolution_selected"
            label="Screen Resolution"
            item-text="disp"
            item-value="val"
            required
          ></v-select>

          <v-text-field
            label="RAM"
            v-model="RAM"
            suffix="GB"
            type="number"
            min="1"
            max="16"
          ></v-text-field>
          <v-text-field
            label="ROM"
            v-model="ROM"
            suffix="GB"
            type="number"
            min="4"
            max="1024"
          ></v-text-field>
          <v-text-field
            label="Battery"
            v-model="battery"
            suffix="mAh"
            type="number"
            min="500"
            max="10000"
          ></v-text-field>

          <v-btn color="success" class="mr-4" @click="predict"> Predict </v-btn>
          <v-btn color="error" @click="reset"> Reset Form </v-btn>
        </v-form>
        <v-card class="predict-container" elevation="2" v-show="show_price">
          <v-progress-circular
            indeterminate
            color="primary"
            v-if="loading"
          ></v-progress-circular>
          <p class="price" v-else>
            Price predict: <span>{{ price }} VND</span>
          </p></v-card
        >
      </div>
    </v-main>
    <v-footer padless>
      <v-col class="text-center" cols="12">
        Make by — <a href="https://github.com/ngovandong">ngovandong</a>
      </v-col>
    </v-footer>
  </v-app>
</template>

<script>
export default {
  name: "App",
  data: () => ({
    price: 0,
    error: false,
    show_price: false,
    loading: true,
    scr_typ_selected: null,
    scr_typ: [
      { disp: "LCD", val: 0 },
      { disp: "OLED", val: 1 },
    ],
    net_selected: null,
    nets: [
      { disp: "4G", val: 4 },
      { disp: "5G", val: 5 },
    ],
    os_selected: null,
    oses: [
      { disp: "Android", val: 0 },
      { disp: "IOS", val: 1 },
    ],
    chip_selected: null,
    chips: [
      { disp: "Apple bionic", val: 0 },
      { disp: "Exynos", val: 1 },
      { disp: "Mediatek", val: 2 },
      { disp: "Snapdragon", val: 3 },
    ],
    RAM: null,
    ROM: null,
    battery: null,
    resolution_selected: null,
    resolutions: [
      { disp: "VGA", val: 307200 },
      { disp: "HD", val: 921600 },
      { disp: "Full HD", val: 2073600 },
      { disp: "2K", val: 3686400 },
    ],
  }),

  methods: {
    validate() {
      return (
        this.ROM &&
        this.RAM &&
        this.resolution_selected &&
        this.battery &&
        this.os_selected &&
        this.net_selected &&
        this.scr_typ_selected &&
        this.chip_selected
      );
    },
    reset() {
      this.$refs.form.reset();
      this.show_price = false;
    },

    predict() {
      this.error = this.validate() == null;
      if (!this.error) {
        this.show_price = true;
        fetch("https://mobile-price-predict.azurewebsites.net/predict/", {
          method: "POST",
          headers: {
            Accept: "application/json",
            "Content-Type": "application/json",
          },
          body: JSON.stringify({
            scr_type: this.scr_typ_selected,
            chip: this.chip_selected,
            OS: this.os_selected,
            RAM: this.RAM * 1024,
            ROM: this.ROM * 1024,
            scr_res: this.resolution_selected,
            battery: this.battery,
            net: this.net_selected,
          }),
        })
          .then((res) => res.json())
          .then((data) => {
            this.price = Math.round(data.price * 1000);
            this.loading = false;
          })
          .catch((error) => console.log(error));
      }
    },
  },
};
</script>

<style scoped>
.caption {
  font-weight: bold;
}
.container {
  max-width: 800px;
  margin: 5% auto;
}
.predict-container {
  height: 100px;
  margin-top: 50px;
  display: flex;
  justify-content: center;
  align-items: center;
}
.price {
  font-size: 28px;
}
.price span {
  color: #ff5252;
  font-weight: bold;
}
</style>
